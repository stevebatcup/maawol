module Maawol
	module SubscriptionHelper
		def subscription_option_full_text(option)
			if option.days < 365
				"#{option.monthly_price("<span class='currency'>&dollar;</span>", true)}<span class='month'> / month</span>"
			else
				"#{option.yearly_price("<span class='currency'>&dollar;</span>", true)}<span class='month'> / year</span>"
			end
		end
	end
end