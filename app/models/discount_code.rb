class DiscountCode < ApplicationRecord
	has_many	:subscription_options, class_name: 'DiscountCodeSubscriptionOption'
	attr_accessor	:discounted_options

	def self.apply_discount_code_to_option(discount_code, actual_subscription_option)
		if dcode = self.find_by_code(discount_code)
			discounted_option = dcode.subscription_options.find_by_subscription_option_id(actual_subscription_option.id)
			actual_subscription_option = discounted_option.apply_to_actual_subscription_option(actual_subscription_option)
		end
		actual_subscription_option
	end

	def self.find_and_build_options_by_code(submitted_code)
		if dcode = self.find_by_code(submitted_code)
			now = Time.now
			if dcode.valid_from < now && dcode.valid_to > now
				dcode.increment!(:use_count)
				dcode.discounted_options = []
				dcode.subscription_options.order(:display_sort).each do |discounted_option|
					actual_subscription_option = SubscriptionOption.find(discounted_option.subscription_option_id)
					actual_subscription_option = discounted_option.apply_to_actual_subscription_option(actual_subscription_option)
					dcode.discounted_options << actual_subscription_option
				end
				dcode
			end
		end
	end
end