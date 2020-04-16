json.set! :items do
	json.array! @products do |product|
		item = product.productable
		json.id product.id
		json.name item.name
		json.nameWithType item.name_with_type
		json.price product.price.nil? ? '' : number_to_currency(product.price, unit: Maawol::Config.currency_symbol)
		json.image item.image.url.nil? ? '' : item.image.url(:large)
		json.accessLink can_be_accessed_by_user_without_purchase?(item) ? product_access_url(item) : nil
		json.accessLabel can_be_accessed_by_user_without_purchase?(item) ? product_access_label(item) : ''
	end
end
