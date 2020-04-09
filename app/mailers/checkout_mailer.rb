class CheckoutMailer < ApplicationMailer
	def products_purchased(email, first_name, product_permissions)
		vars = {
			"FNAME" => first_name,
			"FILE_LINKS" => build_file_links(product_permissions)
		}
		subject = "Here are the custom links for your purchases"
		body = mandrill_template('file-purchased', merge_vars(vars))
		send_non_user_mail(email, subject, body)
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