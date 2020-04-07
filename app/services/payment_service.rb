module Maawol
	module PaymentService
		def self.calculate_details(current_user, subscription_level, discount_code, payment_system=:card)
			chosen_option = SubscriptionOption.find_by_level(subscription_level)
			custom_option = CustomUserSubscriptionOption.where(user_id: current_user.id, redeemed: false).first
			if chosen_option.custom? && custom_option && (custom_option.subscription_option_id == chosen_option.id)
				future_start = Time.now + chosen_option.days.to_i.days
			else
				future_start = nil
				if payment_system == :card && current_user.has_current_ending_card_subscription?
					future_start = current_user.current_ending_subscription.ends_at
				elsif payment_system == :paypal && current_user.has_current_ending_paypal_subscription?
					future_start = current_user.current_ending_subscription.ends_at
				end
			end
			{
				chosen_option: chosen_option,
				custom_option: custom_option,
				future_start: future_start,
				initial_price: UsersSubscriptionPayment.initial_price_to_pay(chosen_option, discount_code)
			}
		end

		def self.cancel_recurring_billing(subscription, site_name)
			if subscription.is_paypal?
				PaymentService::Paypal.cancel(subscription, site_name)
			elsif subscription.is_card?
				PaymentService::Chargebee.cancel(subscription)
			else
				false
			end
		end
	end
end