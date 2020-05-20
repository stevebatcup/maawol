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
			render json: { status: :error, message: t('controllers.basket.update.error') }
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
			render json: { status: :error, message: t('controllers.basket.destroy.error') }
		end
	end

private

	def total_price(basket)
		number_to_currency('%.2f' % (basket.total.cents.to_i/100.0), unit: Maawol::Config.currency_symbol)
	end
	helper_method	:total_price

	def add_to_basket(product)
		if basket.add(product, product.price)
			render json: { status: :success, total: total_price(basket) }
		else
			render json: { status: :error, message: t('controllers.basket.add_to_basket.error') }
		end
	end

	def remove_from_basket(product, quantity=1)
		if basket.remove(product, quantity)
			render json: { status: :success, total: total_price(basket) }
		else
			render json: { status: :error, message: t('controllers.basket.remove_from_basket.error') }
		end
	end
end