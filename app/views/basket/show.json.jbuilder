json.status @status
json.message @message if @message
if @basket.shopping_cart_items.any?
	json.set! :items do
		json.array! @basket.shopping_cart_items do |item|
			json.product do
				json.id item.item.id
				json.name item.item.productable.name
				json.nameWithType item.item.productable.name_with_type
				json.price number_to_currency(item.item.price)
			end
			json.quantity item.quantity
		end
	end
	json.store do
		store = @basket.shopping_cart_items.last.item.store
		json.url store.full_path
		json.name store.name
	end
end
json.total total_price(@basket)