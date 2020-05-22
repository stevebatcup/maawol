module Payment
	module Chargebee
		class Subscription < Service

			attr_accessor	:payment_system, :card_details

			def initialize(options)
				self.payment_system = :card
				self.card_details = options[:card_details]

				super(options)
			end

			def	create
				if subscription.save
					redeem_discount_code if session_discount_code.present?
					current_user.update_attribute(:status, :paying)
					custom_option.update_attribute(:redeemed, :true) if custom_option
				end
				subscription
			end

			def self.cancel(subscription)
				subscription_id = subscription.remote_subscription_id
				if result = ChargeBee::Subscription.cancel(subscription_id)
					log(subscription.user, :cancel_subscription, { subscription_id: subscription_id }, result)
					result
				end
			end

			def self.update_card_details(subscription, card)
				card_data = chargebee_card_data(card)
				result = ChargeBee::Card.update_card_for_customer(subscription.remote_customer_id, card_data)
				data = {
					customer_id: subscription.remote_customer_id,
					card: card_data
				}
				log(subscription.user, :update_card_details, mask_data(data), result)
				result
			end

		private

			def chargebee_coupon_code
				@chargebee_coupon_code ||= begin
					code = nil
					if session_discount_code && (initial_price < chosen_option.price)
						code = session_discount_code
					end
				end
			end

			def subscription
				current_user.build_new_subscription({
					remote_subscription: remote_subscription,
					future_start: start_date,
					subscription_option: chosen_option,
					initial_price: initial_price,
					discount_code: (chargebee_coupon_code.present? ? DiscountCode.find_by_code(chargebee_coupon_code) : nil)
				})
			end

			def plan_id
				"#{chosen_option.payment_system_plan}_#{Maawol::Config.currency_code.downcase}"
			end

			def remote_subscription
				if future_start.nil?
					first_subscribe
				else
					current_user.current_ending_subscription.present? ? resubscribe : custom_subscribe
				end
			end

			def first_subscribe
				data = {
					plan_id: plan_id,
					plan_unit_price: recurring_price_in_pence,
					status: :active,
					customer: { email: current_user.email, first_name: current_user.first_name, last_name: current_user.last_name },
					card: chargebee_card_data(card_details),
					currency_code: Maawol::Config.currency_code
				}
				data[:coupon_ids] = [chargebee_coupon_code] if chargebee_coupon_code.present?
				if result = ChargeBee::Subscription.create(data)
					log(current_user, :first_subscribe, mask_data(data), result)
					result
				end
			end

			def resubscribe
				data = {
					plan_id: plan_id,
					plan_unit_price: recurring_price_in_pence,
					status: :future,
					card: chargebee_card_data(card_details),
					start_date: start_date.to_time.to_i,
					currency_code: Maawol::Config.currency_code
				}
				data[:coupon_ids] = [chargebee_coupon_code] if chargebee_coupon_code.present?
				customer_id = current_user.current_ending_subscription.remote_customer_id
				if result = ChargeBee::Subscription.create_for_customer(customer_id, data)
					log(current_user, :resubscribe, mask_data(data), result)
					result
				end
			end

			def custom_subscribe
				data = {
					plan_id: plan_id,
					plan_unit_price: recurring_price_in_pence,
					status: :active,
					customer: { email: current_user.email, first_name: current_user.first_name, last_name: current_user.last_name },
					card: chargebee_card_data(card_details),
					start_date: start_date.to_time.to_i,
					currency_code: Maawol::Config.currency_code
				}
				if result = ChargeBee::Subscription.create(data)
					log(current_user, :custom_subscribe, mask_data(data), result)
					result
				end
			end

			def recurring_price_in_pence
				(recurring_price*100).to_i
			end
		end
	end
end