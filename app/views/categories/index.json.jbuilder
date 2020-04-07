if @categories
	json.array! @categories do |category|
		json.id category.id
		json.name category.name
	end
end