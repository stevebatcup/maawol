class CheckoutMailer < MaawolMailer
	def products_purchased(email, first_name, product_permissions)
		merge_vars = {
			"FNAME" => first_name,
			"PRODUCT_LINKS" => build_file_links(product_permissions)
		}
		subject = "Thanks for your purchases"
		body = template('store-receipt', merge_vars)
		send_mail(email, subject, body, first_name)
	end

	def build_file_links(permissions)
		html = "<ul>"
		permissions.each do |permission|
			html << "<li><a href='#{permission.full_url}'>#{permission.product.productable.name_with_type}</a></li>"
		end
		html << "</ul>"
		html
	end
end