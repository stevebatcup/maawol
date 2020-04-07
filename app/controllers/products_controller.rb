class ProductsController < MaawolController
	def index
		store = Store.find(params[:store_id])
		@products = store.products
		@products = @products.where.not(price: nil) unless user_signed_in? && current_user.is_subscriber?
	end
end