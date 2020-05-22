module Payment
	module Chargebee
		class SinglePayment < Service

			attr_accessor	:payment_details, :basket, :description, :currency_code

			def initialize(options)
				self.payment_details = options[:payment]
				self.basket = options[:basket]
				self.description = options[:description]
				self.currency_code = options[:currency_code]
			end

			def create
				invoice = charge_single_payment_invoice
				ApiLog.request({
					service: :chargebee,
					user_id:  nil,
					request_method: :create_store_payment,
					request_data: payment_data,
					response: { invoice: invoice.to_json }
			  })
				yield invoice
			end

		private

			def payment_data
			 	@payment_data ||= begin
				 	{
						customer_id: single_payment_customer.id,
						amount: basket.total.cents,
						description: description,
						currency_code: currency_code
					}
				end
			end

			def charge_single_payment_invoice
				ChargeBee::Invoice.charge(payment_data).invoice()
			end

			def single_payment_customer
				ChargeBee::Customer.create({
					email: payment_details[:email],
					card: chargebee_card_data(payment_details)
				}).customer()
			end
		end
	end
end