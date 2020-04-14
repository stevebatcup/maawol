module PaymentService
	module Chargebee

		def self.do_payment(options)
			customer = build_files_payment_customer(options[:payment])
			invoice = build_files_payment_invoice(customer, options[:basket].total.cents, options[:description], options[:currency])
			yield invoice
		end

		def self.build_files_payment_invoice(customer, total, description, currency)
			data = {
				customer_id: customer.id,
				amount: total,
				description: description,
				currency_code: currency
			}
			ChargeBee::Invoice.charge(data).invoice()
		end

		def self.build_files_payment_customer(payment_details)
			@files_payment_customer ||= begin
				ChargeBee::Customer.create({
					email: payment_details[:email],
					card: self.chargebee_card_data(payment_details)
				}).customer()
			end
		end

		def	self.do_subscription_payment(options)
			payment_details = PaymentService.calculate_details(options[:current_user],
																													options[:subscription_level],
																													options[:session_discount_code],
																													:card)

			chargebee_coupon_code = nil
			if options[:session_discount_code] && (payment_details[:initial_price] < payment_details[:chosen_option].price)
				chargebee_coupon_code = options[:session_discount_code]
			end

			remote_subscription = self.subscribe({
				user: options[:current_user],
				card: options[:card_details],
				subscription_option: payment_details[:chosen_option],
				future_start: payment_details[:future_start],
				discount_code: chargebee_coupon_code
			})

			discount_code = nil
			if chargebee_coupon_code
				discount_code = DiscountCode.find_by_code(chargebee_coupon_code)
			end

			subscription = options[:current_user].build_new_subscription({
				remote_subscription: remote_subscription,
				future_start: payment_details[:future_start],
				subscription_option: payment_details[:chosen_option],
				initial_price: payment_details[:initial_price],
				discount_code: discount_code
			})
			if subscription.save
				discount_code.increment!(:redemption_count) if discount_code
				options[:current_user].update_attribute(:status, :paying)
				payment_details[:custom_option].update_attribute(:redeemed, :true) if payment_details[:custom_option]
			end
			subscription
		end

		def self.log(user, action, request, result)
			response = {
				customer: result.customer,
				subscription: result.subscription,
				card: result.card
			}.to_json

			ApiLog.request({
				service: :chargebee,
				user_id:  user ? user.id : nil,
				request_method: action,
				request_data: request,
				response: response
		  })
		end

		def self.subscribe(options)
			if options[:future_start].nil?
				self.first_subscribe(options[:user],
															options[:card],
															options[:subscription_option].payment_system_plan,
															options[:discount_code])
			else
				if options[:user].current_ending_subscription.present?
					self.resubscribe(
						options[:user],
						options[:card],
						options[:subscription_option].payment_system_plan,
						options[:future_start],
						options[:discount_code]
					)
				else
					self.custom_subscribe(options[:user],
						options[:card],
						options[:subscription_option].payment_system_plan,
						options[:future_start]
					)
				end
			end
		end

		def self.first_subscribe(user, card, plan_id, discount_code)
			data = {
				plan_id: plan_id,
				status: :active,
				customer: { email: user.email, first_name: user.first_name, last_name: user.last_name },
				card: self.chargebee_card_data(card)
			}
			data[:coupon_ids] = [discount_code] if discount_code.present?
			if result = ChargeBee::Subscription.create(data)
				log(user, :first_subscribe, self.mask_data(data), result)
				result
			end
		end

		def self.custom_subscribe(user, card, plan_id, future_start)
			data = {
				plan_id: plan_id,
				status: :active,
				customer: { email: user.email, first_name: user.first_name, last_name: user.last_name },
				card: self.chargebee_card_data(card),
				start_date: future_start.to_time.to_i
			}
			if result = ChargeBee::Subscription.create(data)
				log(user, :custom_subscribe, self.mask_data(data), result)
				result
			end
		end

		def self.resubscribe(user,
													card,
													plan_id,
													future_start,
													discount_code)
			data = {
				plan_id: plan_id,
				status: :future,
				card: self.chargebee_card_data(card),
				start_date: future_start.to_time.to_i
			}
			data[:coupon_ids] = [discount_code] if discount_code.present?
			customer_id = user.current_ending_subscription.remote_customer_id
			if result = ChargeBee::Subscription.create_for_customer(customer_id, data)
				log(user, :resubscribe, self.mask_data(data), result)
				result
			end
		end

		def self.chargebee_card_data(card)
			{
				gateway: Rails.application.credentials.chargebee[:gateway],
				number: card[:cardNumber],
				type: card[:type],
				expiry_month: card[:expiry][:month],
				expiry_year: card[:expiry][:year],
				cvv:  card[:cv2]
			}
		end

		def self.build_plan_id(level=3)
			"subscription-#{level}"
		end

		def self.cancel(subscription)
			subscription_id = subscription.remote_subscription_id
			if result = ChargeBee::Subscription.cancel(subscription_id)
				log(subscription.user, :cancel_subscription, { subscription_id: subscription_id }, result)
				result
			end
		end

		def self.detect_card_errors(card)
			detector = CreditCardValidations::Detector.new(card[:cardNumber])
			error_msg = false
			if card[:type] == 'visa' && !detector.visa?
				error_msg = "Please enter a valid VISA card number"
			elsif card[:type] == 'mastercard' && !detector.mastercard?
				error_msg = "Please enter a valid Mastercard number"
			end
			error_msg
		end

		def self.update_card_details(subscription, card)
			card_data = self.chargebee_card_data(card)
			result = ChargeBee::Card.update_card_for_customer(subscription.remote_customer_id, card_data)
			data = {
				customer_id: subscription.remote_customer_id,
				card: card_data
			}
			log(subscription.user, :update_card_details, self.mask_data(data), result)
			result
		end

		def self.mask_data(data)
			last_digits = data[:card][:number].to_s.slice(-4..-1)
			data[:card][:number] = "************#{last_digits}"
			data[:card][:cvv] = "***"
			data[:card][:expiry_month] = "**"
			data[:card][:expiry_year] = "****"
			data
		end
	end
end