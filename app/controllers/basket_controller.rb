class BasketController < MaawolController
	include ActionView::Helpers::NumberHelper

	def update
		if product = Product.find(params[:id])
			if params[:method] == :add
				add_to_basket(product)
			elsif params[:method] == :remove
				remove_from_basket(product, params[:quantity])
			end
		else
			render json: { status: :error, message: "Sorry we cannot find that item for your basket." }
		end
	end

	def show
		@basket = basket
		@status = :success
	end

	def destroy
		if basket.clear
			render json: { status: :success, total: total_price(basket) }
		else
			render json: { status: :error, message: "Sorry there was an error clearing your basket." }
		end
	end

private

	def total_price(basket)
		number_to_currency('%.2f' % (basket.total.cents.to_i/100.0))
	end
	helper_method	:total_price

	def add_to_basket(product)
		if basket.add(product, product.price)
			render json: { status: :success, total: total_price(basket) }
		else
			render json: { status: :error, message: "There was an error adding this to your basket" }
		end
	end

	def remove_from_basket(product, quantity=1)
		if basket.remove(product, quantity)
			render json: { status: :success, total: total_price(basket) }
		else
			render json: { status: :error, message: "There was an error removing this from your basket" }
		end
	end
end