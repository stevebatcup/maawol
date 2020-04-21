class SubscriptionDiscountsController < MaawolController
	before_action :require_login

	def create
		if params[:apply_discount_code]
			if @discount = DiscountCode.find_and_build_options_by_code(params[:apply_discount_code])
				session[:discount_code] = @discount.code
				@status = :success
			else
				@status = :error
			end
		else
			@status = :error
		end
		@message = t('views.subscription.discount.error.invalid') if @status == :error
	end

	def show
		@discount_code = session[:discount_code] || nil
	end
end