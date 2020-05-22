module Payment
	module Paypal
		class SinglePayment < Service

			attr_accessor	:basket, :currency_code, :domain, :description

			def initialize(options)
				self.basket = options[:basket]
				self.currency_code = options[:currency_code]
				self.domain = options[:domain]
				self.description = options[:description]
			end

			def create
				@payment = PayPal::SDK::REST::Payment.new(payment_data)
				result = @payment.create
				log(nil, :create_store_payment, payment_data, @payment.to_json)
			  yield(result ? :success : :error, @payment) if block_given?
			end

			def self.finalise_payment_for_files(payment_id, token, payer_id)
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

		private

			def payment_data
				{
					:intent =>  "sale",
					:payer =>  {
						:payment_method =>  "paypal"
					},
					:redirect_urls => {
						:return_url => "#{domain}/checkout/paypal/success",
						:cancel_url => "#{domain}/checkout/paypal/cancel"
					},
					:transactions =>  [{
						:item_list => {
							:items => basket_items
						},
						:amount =>  {
							:total =>  ('%.2f' % (basket.total.cents.to_i/100.0)).to_s,
							:currency =>  currency_code
						},
						:description =>  description
					}]
				}
			end

			def basket_items
				items = []
				basket.shopping_cart_items.each do |basket_item|
					items << {
						:name => basket_item.item.productable.name,
						:price => basket_item.item.price,
						:currency => currency_code,
						:quantity => basket_item.quantity
					}
				end
				items
			end

		end
	end
end
