class CheckoutController < MaawolController
	def new
		if params[:token] && params[:paypal_cancelled].nil?
			@singlecheckout = true
			basket.clear if basket.shopping_cart_items.any?
			downloadable = Downloadable.find_by(token: params[:token])
			if downloadable
				product = Product.find_by(downloadable_id: downloadable.id)
				basket.add(product, product.price)
			end
		else
			@singlecheckout = false
			@paypal_cancelled = params[:paypal_cancelled].present?
		end
	end

	def create
		if session[:basket_id] && basket.shopping_cart_items.any?
			begin
				options = {
					payment: payment_params,
					basket: basket,
					description: payment_description,
					currency: site_setting("Currency code") || "USD",
					domain: Maawol::Config.site_host
				}
				if payment_params[:type] == 'paypal'
					PaymentService::Paypal.create_payment(options) do |status, payment|
						basket.update_attribute(:paypal_payment_id, payment.id)
						@status = status
						if status == :success
							@paypal_redirect = payment.links.find{|v| v.method == "REDIRECT" }.href
						else
							@error = payment.error.message
						end
					end
				else
					PaymentService::Chargebee.do_payment(options) do |invoice|
						if invoice && invoice.status == "paid"
							@status = :success
							complete_checkout(payment_params[:email], payment_params[:firstName], payment_params[:lastName], :chargebee)
						else
							@status = :error
							@error = "An unknown error occurred whilst processing your card payment, please try again."
						end
					end
				end
			rescue Exception => e
				@status = :error
				@error = e.message
			end
		else
			@status = :error
			@error = empty_basket_msg
		end
	end

	def update # redirected from paypal
		begin
			PaymentService::Paypal.execute_payment_for_files(params[:paymentId], params[:token], params[:PayerID]) do |email, first_name, last_name|
				complete_checkout(email, first_name, last_name, :paypal)
				redirect_to checkout_complete_path
			end
		rescue Exception => e
			@paypal_error = true
			record_payments_from_basket_items(:failed, :paypal)
			flash.now[:alert] = "Oops there's been a problem completing your Paypal payment, please try again. <br /><b>Error: #{e.message}</b>".html_safe
			render action: 'new'
		end
	end

	def show
		@purchased_permissions = []
		if session[:purchased_permissions]
			session[:purchased_permissions].each { |id| @purchased_permissions << ProductPermission.find_by(id: id) }
			session.delete(:purchased_permissions)
		end
	end

private
	def build_file_permissions_from_basket_items
		permissions = []
		basket.shopping_cart_items.each do |basket_item|
			permission = basket_item.item.product_permissions.create({ expires_at: ProductPermission.default_expires_at })
			permissions << permission
		end
		permissions
	end

	def complete_checkout(email, first_name, last_name, payment_system=:chargebee)
		permissions = build_file_permissions_from_basket_items
		session[:purchased_permissions] = permissions.map(&:id)
		record_payments_from_basket_items(:paid, payment_system, email, first_name, last_name)
		CheckoutMailer.products_purchased(email, first_name, permissions).deliver_now
		basket.clear
	end

	def record_payments_from_basket_items(status, payment_system, email=nil, first_name=nil, last_name=nil)
		basket.shopping_cart_items.each do |basket_item|
			ProductPayment.create({
				product_id: basket_item.item.id,
				amount: '%.2f' % (basket_item.price_cents.to_i/100.0),
				payment_system: payment_system,
				status: status,
				email: email,
				first_name: first_name,
				last_name: last_name
			})
		end
	end

	def payment_description
		@payment_description ||= begin
			store = basket.shopping_cart_items.first.item.store
			"#{basket.shopping_cart_items.length} item#{'s' if basket.shopping_cart_items.length > 1} from the #{store.name} store"
		end
	end

	def payment_params
		params[:payment]
	end

	def empty_basket_msg
		"There are no items in your basket"
	end
end