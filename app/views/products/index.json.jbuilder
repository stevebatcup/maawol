json.set! :items do
	json.array! @products do |product|
		item = product.productable
		json.id product.id
		json.name item.name
		if item.is_a?(AudioFile)
			json.isAudioFile true
			json.audioUrl item.file.url
			json.image asset_url('transparent-100x67.png')
		else
			json.isAudioFile false
			json.image item.has_image? ? item.image.url(:large) : ''
		end
		json.nameWithType item.name_with_type
		json.price product.price.nil? ? '' : number_to_currency(product.price, unit: Maawol::Config.currency_symbol)
		json.accessLink can_be_accessed_by_user_without_purchase?(item) ? product_access_url(item) : nil
		json.accessLabel can_be_accessed_by_user_without_purchase?(item) ? product_access_label(item) : ''
	end
end
