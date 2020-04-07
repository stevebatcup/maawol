class SubscriptionOptionsController < MaawolController
	respond_to :json

	def index
		custom_option = CustomUserSubscriptionOption.where(user_id: current_user.id, redeemed: false).first
		if params[:migration] && custom_option
			subscription_option = SubscriptionOption.find(custom_option.subscription_option_id)
			@options = [subscription_option]
			@selectedLevel = subscription_option.level
		else
			@options = SubscriptionOption.where(custom: false).order(:display_sort)
			if most_popular = @options.find_by(tag: 'most-popular')
				@selectedLevel = most_popular.level
			else
				@selectedLevel = @options.first.level
			end
		end
	end

	def show
		@option = SubscriptionOption.find_by_months(params[:id])
		if session[:discount_code]
			@option = DiscountCode.apply_discount_code_to_option(session[:discount_code], @option)
		end
	end
end