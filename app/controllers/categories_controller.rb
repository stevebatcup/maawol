class CategoriesController < MaawolController
	def index
		if params[:root]
			@categories = Category.order(id: :asc).where(root_category_id: params[:root])
		else
			@categories = Category.order(id: :asc).all
		end
	end
end