class DiscountCodeSubscriptionOption < ApplicationRecord
	def apply_to_actual_subscription_option(actual_subscription_option)
		if self.discount_type.to_sym == :percentage
			if self.discount_value.to_i > 0
				factor = (100 - self.discount_value.to_i).to_f / 100
				new_price = actual_subscription_option.price * factor
				actual_subscription_option.discounted_price = new_price.round(2)
				actual_subscription_option.discounted_by = self.discount_value
			else
				actual_subscription_option.discounted_price = actual_subscription_option.price
				actual_subscription_option.discounted_by = 0
			end
		elsif self.discount_type.to_sym == :free_months
			actual_subscription_option.extra_months = self.discount_value
		end
		actual_subscription_option
	end
end