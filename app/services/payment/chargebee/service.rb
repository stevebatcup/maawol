module Payment
	module Chargebee
		class Service < Payment::Service

			def initialize(options)
				super(options)
			end

			def self.detect_card_errors(card_details)
				detector = CreditCardValidations::Detector.new(card_details[:cardNumber])
				error_msg = false
				if card_details[:type] == 'visa' && !detector.visa?
					error_msg = I18n.t('payments.card_errors.invalid.visa')
				elsif card_details[:type] == 'mastercard' && !detector.mastercard?
					error_msg = I18n.t('payments.card_errors.invalid.mastercard')
				end
				error_msg
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

			def self.chargebee_card_data(card)
				{
					gateway_account_id: Maawol::Config.chargebee_gateway,
					number: card[:cardNumber],
					type: card[:type],
					expiry_month: card[:expiry][:month],
					expiry_year: card[:expiry][:year],
					cvv:  card[:cv2]
				}
			end

			def self.mask_data(data)
				last_digits = data[:card][:number].to_s.slice(-4..-1)
				data[:card][:number] = "************#{last_digits}"
				data[:card][:cvv] = "***"
				data[:card][:expiry_month] = "**"
				data[:card][:expiry_year] = "****"
				data
			end

		protected

			def log(user, action, request, result)
				self.class.log(user, action, request, result)
			end

		end
	end
end