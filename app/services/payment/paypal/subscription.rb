module Payment
	module Paypal
		class Subscription < Service

			attr_accessor	:payment_system, :site_name, :return_url, :cancel_url, :currency_code

			def initialize(options)
				self.payment_system = :paypal
				self.site_name = options[:site_name]
				self.return_url = options[:return_url]
				self.cancel_url = options[:cancel_url]
				self.currency_code = options[:currency_code]

				super(options)
			end

			def create
				if local_subscription_item.errors.any?
					recurring_plan.error = local_subscription_item.errors.full_messages
					recurring_plan
				else
					(recurring_plan unless recurring_plan.success?) || recurring_agreement
				end
			end

			def self.complete_agreement(current_user, token, session)
				agreement = execute_agreement(token, current_user)
				pending_subscription = current_user.get_pending_paypal_subscription
				redeem_custom_option if pending_subscription.subscription_option.custom
				pending_subscription.finalise_paypal(agreement)
				current_user.update_attribute(:status, :paying)
				redeem_discount_code if session[:discount_code].present?
			end

			def self.redeem_custom_option
				custom_option = CustomUserSubscriptionOption.where(user_id: current_user.id, redeemed: false).first
				custom_option.update_attribute(:redeemed, :true)
			end

		  def self.execute_agreement(agreement_token, user)
		  	agreement = PayPal::SDK::REST::Agreement.new(token: agreement_token)
		    agreement.execute unless agreement.error
				log(user, :execute_agreement, { agreement_id: agreement.id }, agreement.to_json)
		    agreement
		  end

			def self.cancel(subscription, site_name)
				if agreement = PayPal::SDK::REST::Agreement.find(subscription.remote_subscription_id)
					if result = agreement.cancel({note: "Cancelled on #{site_name} website"})
						log_data = {result: "success"}
						result
					else
						log_data = {result: "fail", reason: agreement.error}
						false
					end
					log(subscription.user, :cancel_subscription, { subscription_id: subscription.remote_subscription_id }, log_data)
				else
					false
				end
			end

		private

			def local_subscription_item
				@local_subscription_item ||= begin
					current_user.find_or_create_pending_paypal_subscription({
				  	initial_price: initial_price,
				  	subscription_option: chosen_option,
				  	future_start: future_start,
				  	discount_code: session_discount_code
				  })
				end
			end

			def recurring_plan
				@recurring_plan ||= begin
			    plan = PayPal::SDK::REST::Plan.new(plan_data)
					log(current_user, :create_plan, { recurring_price: recurring_price }, plan.to_json)
			    plan.update(active_data) if plan.create
			    plan # If any error occured, the message will be saved in plan.error
			  end
		  end

			def plan_data
				data = {
				  name: "#{site_name} recurring plan",
				  description: "Recurring payment plan for #{site_name}",
				  type: "INFINITE",
				  merchant_preferences: {
				  	return_url: return_url,
				  	cancel_url: cancel_url,
				  	max_fail_attempts: 1
				  },
				  payment_definitions: [{
				    "name": "#{site_name} Regular payment",
				    "type": "REGULAR",
				    "frequency": "MONTH",
				    "frequency_interval": "#{chosen_option.months}",
				    "amount": {
				      "value": chosen_option.price,
				      "currency": currency_code
				    },
				    "cycles": "0"
				  }]
				}
			end

		  def active_data
		  	{
		      op: "replace",
		      value: { state: "ACTIVE" },
		      path: "/"
		    }
		  end

			def recurring_agreement
				agreement = PayPal::SDK::REST::Agreement.new(agreement_data)
				agreement.create
				log(current_user, :create_agreement, { plan_id: recurring_plan.id }, agreement.to_json)
				DevMailer.notify_error_paypal_agreement(agreement).deliver_now if agreement.error
				agreement # If any error occured, the message will be saved in agreement.error
			end

			def agreement_data
				to_pay_now = initial_price.to_i == 0 ? 'Nothing to pay now' : "#{Maawol::Config.currency_symbol}#{('%.2f' % initial_price)} now"
				start_at = start_date + monthly_frequency.send(:months) if initial_price.to_i > 0
				monthly_desc = monthly_frequency == 1 ? 'per month' : "every #{monthly_frequency} months"
				friendly_start_at = start_at.strftime('%B %d, %Y')
				data = {
					name: "#{site_name} billing agreement",
					description: "#{Maawol::Config.site_name} subscription: #{to_pay_now} then
												#{Maawol::Config.currency_symbol}#{('%.2f' % recurring_price)} #{monthly_desc}
												starting on #{friendly_start_at}",
					start_date: start_at.strftime('%Y-%m-%dT%H:%M:%S.%L%z'),
					payer: { payment_method: "paypal" },
					plan: { id: recurring_plan.id },
					override_merchant_preferences: {
						setup_fee: {
							"value": initial_price,
							"currency": currency_code
						}
					}
				}
			end

			def monthly_frequency
				@monthly_frequency ||= chosen_option.months
			end
		end
	end
end
