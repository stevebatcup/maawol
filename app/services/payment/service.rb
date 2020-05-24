module Payment
	class Service

		attr_accessor	:current_user, :subscription_level, :session_discount_code, :chosen_option, :custom_option, :recurring_price

		def initialize(options)
			self.current_user = options[:current_user]
			self.subscription_level = options[:subscription_level]
			self.session_discount_code = options[:session_discount_code]
			self.chosen_option = SubscriptionOption.find_by_level(subscription_level)
			self.custom_option = CustomUserSubscriptionOption.where(user_id: current_user.id, redeemed: false).first
			self.recurring_price = chosen_option.price
		end

		def initial_price
			@initial_price ||= begin
				chosen_option.custom? ? 0 : UsersSubscriptionPayment.initial_price_to_pay(chosen_option, session_discount_code)
			end
		end

		def start_date
			@start_date ||= (future_start.present? ? future_start : Time.now)
		end

		def future_start
			if has_chosen_custom_option?(chosen_option, custom_option)
				future_start = Time.now + chosen_option.days.to_i.days
			elsif payment_system == :card && current_user.has_current_ending_card_subscription?
				future_start = current_user.current_ending_subscription.ends_at
			elsif payment_system == :paypal && current_user.has_current_ending_paypal_subscription?
				future_start = current_user.current_ending_subscription.ends_at
			else
				future_start = nil
			end
		end

		def has_chosen_custom_option?(chosen_option, custom_option)
			chosen_option.custom? && custom_option && (custom_option.subscription_option_id == chosen_option.id)
		end

		def redeem_discount_code
			if discount_code = DiscountCode.find_by_code(session[:discount_code])
				discount_code.increment!(:redemption_count)
			end
			session.delete(:discount_code)
		end
	end
end