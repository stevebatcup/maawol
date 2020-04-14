module PaymentService
	module Paypal

		def self.create_payment(options)
			items = []
			options[:basket].shopping_cart_items.each do |basket_item|
				items << {
					:name => basket_item.item.productable.name,
					:price => basket_item.item.price,
					:currency => options[:currency],
					:quantity => basket_item.quantity
				}
			end

			payment_data = {
				:intent =>  "sale",
				:payer =>  {
					:payment_method =>  "paypal"
				},
				:redirect_urls => {
					:return_url => "#{options[:domain]}/checkout/paypal/success",
					:cancel_url => "#{options[:domain]}/checkout/paypal/cancel"
				},
				:transactions =>  [{
					:item_list => {
						:items => items
					},
					:amount =>  {
						:total =>  ('%.2f' % (options[:basket].total.cents.to_i/100.0)).to_s,
						:currency =>  options[:currency]
					},
					:description =>  options[:description]
				}]
			}
			@payment = PayPal::SDK::REST::Payment.new(payment_data)

			result = @payment.create
			log(nil, :create_file_payment, payment_data, @payment.to_json)
		  yield(result ? :success : :error, @payment) if block_given?
		end

		def self.execute_payment_for_files(payment_id, token, payer_id)
			payment = PayPal::SDK::REST::Payment.find(payment_id)
			log(nil, :execute_file_payment, { payment_id: payment_id, payer_id: payer_id, token: token }, payment.to_json)
			result = payment.execute(payer_id: payer_id)
			if result
				payer_info = PayPal::SDK::REST::Payment.find(payment_id).payer.payer_info
				yield(payer_info.email, payer_info.first_name, payer_info.last_name)
			else
				raise Exception.new(payment.error.message)
			end
		end

		def self.log(user, action, request, result)
			ApiLog.request({
				service: :paypal,
				user_id: user ? user.id : nil,
				request_method: action,
				request_data: request,
				response: result
		  })
		end

		def self.setup_recurring_billing(options, currency="USD")
			payment_details = PaymentService.calculate_details(options[:current_user],
																													options[:subscription_level],
																													options[:session_discount_code],
																													:paypal)

		  plan = create_recurring_plan(options[:site_name],
		  															payment_details[:chosen_option].price,
															  		options[:return_url],
															  		options[:cancel_url],
															  		options[:current_user],
															  		payment_details[:chosen_option].months,
															  		currency
																  )
		  if plan && plan.success?
		  	initial_price = payment_details[:chosen_option].custom? ? 0 : payment_details[:initial_price]
		  	start_date = payment_details[:future_start] ? payment_details[:future_start] : Time.now
		    agreement = create_agreement(options[:site_name], plan, start_date, initial_price, options[:current_user], payment_details[:chosen_option].months, currency)
		  end

		  options[:current_user].find_or_create_pending_paypal_subscription({
		  	initial_price: initial_price,
		  	subscription_option: payment_details[:chosen_option],
		  	future_start: payment_details[:future_start],
		  	discount_code: options[:session_discount_code]
		  })

		  (plan unless plan.success?) || agreement
		end

		def self.create_recurring_plan(site_name, recurring_price, return_url, cancel_url, user, monthly_frequency=1, currency="USD")
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
          "frequency_interval": "#{monthly_frequency}",
          "amount": {
            "value": recurring_price,
            "currency": currency
          },
          "cycles": "0"
        }]
	    }
	    plan = PayPal::SDK::REST::Plan.new(data)
			log(user, :create_plan, { recurring_price: recurring_price }, plan.to_json)

	    active_data = {
	      op: "replace",
	      value: { state: "ACTIVE" },
	      path: "/"
	    }
	    plan.update(active_data) if plan.create

	    plan # If any error occured, the message will be saved in plan.error
	  end

    def self.create_agreement(site_name, plan, start_date, initial_price, user, monthly_frequency=1, currency="USD")
    	recurring_price = plan.payment_definitions[0].amount.value
    	recurring_price = ('%.2f' % recurring_price)
    	initial_price = ('%.2f' % initial_price)
    	to_pay_now = initial_price.to_i == 0 ? 'Nothing to pay today' : "$#{initial_price} now"
    	start_date = start_date + monthly_frequency.send(:months) if initial_price.to_i > 0
    	monthly_desc = monthly_frequency == 1 ? 'per month' : "every #{monthly_frequency} months"
    	friendly_start_date = start_date.strftime('%B %d, %Y')
    	data = {
	      name: "#{site_name} billing agreement",
	      description: "Monthly subscription. #{to_pay_now} and then $#{recurring_price} #{monthly_desc} starting on #{friendly_start_date}",
	      start_date: start_date.strftime('%Y-%m-%dT%H:%M:%S.%L%z'),
	      payer: { payment_method: "paypal" },
	      plan: { id: plan.id },
	      override_merchant_preferences: {
	      	setup_fee: {
	  	      "value": initial_price,
    	      "currency": currency
    	    }
	      }
	    }
	    agreement = PayPal::SDK::REST::Agreement.new(data)
	    agreement.create
			log(user, :create_agreement, { plan_id: plan.id }, agreement.to_json)

			if agreement.error
				DevMailer.notify_error_paypal_agreement(agreement).deliver_now
			end

	    agreement # If any error occured, the message will be saved in agreement.error
	  end

	  def self.execute_agreement(agreement_token, user)
	  	agreement = PayPal::SDK::REST::Agreement.new(token: agreement_token)
	    agreement.execute unless agreement.error
			log(user, :execute_agreement, { agreement_id: agreement.id }, agreement.to_json)
	    agreement
	  end

	  def self.complete_agreement(current_user, token, session)
			agreement = PaymentService::Paypal.execute_agreement(token, current_user)
	  	pending_subscription = current_user.get_pending_paypal_subscription

	  	if session[:discount_code]
	  		discount_code = DiscountCode.find_by_code(session[:discount_code])
	  		discount_code.increment!(:redemption_count) if discount_code
	  		session.delete(:discount_code)
	  	end

			pending_subscription.update_attributes({
				remote_customer_id: agreement.payer.payer_info.email,
				remote_subscription_id: agreement.id,
				next_payment_due_at: Date.parse(agreement.start_date),
				status: :recurring
			})

	  	if pending_subscription.subscription_option.custom
	  		custom_option = CustomUserSubscriptionOption.where(user_id: current_user.id, redeemed: false).first
	  		custom_option.update_attribute(:redeemed, :true)
	  	end

	  	pending_subscription.send_admin_subscription_email
	  	pending_subscription.send_receipt

			current_user.update_attribute(:status, :paying)
	  end

		def self.cancel(subscription, site_name)
			if agreement = PayPal::SDK::REST::Agreement.find(subscription.remote_subscription_id)
				result = agreement.cancel({note: "Cancelled on #{site_name} website"})
				if result
					log(subscription.user, :cancel_subscription, { subscription_id: subscription.remote_subscription_id }, {result: "success"})
					result
				else
					log(subscription.user, :cancel_subscription, { subscription_id: subscription.remote_subscription_id }, {result: "fail", reason: agreement.error})
					false
				end
			else
				false
			end
		end
	end
end