module Maawol
	module SubscriptionHelper
		def subscription_option_full_text(option)
			if option.days < 365
				"#{option.monthly_price("<span class='currency'>#{Maawol::Config.currency_symbol}</span>", true)}<span class='month'> / month</span>"
			else
				"#{option.yearly_price("<span class='currency'>#{Maawol::Config.currency_symbol}</span>", true)}<span class='month'> / year</span>"
			end
		end

		def monthly_fee
			if fee = SubscriptionOption.find_by(payment_system_plan: :monthly)
				number_to_currency(fee.price.round(2), unit: Maawol::Config.currency_symbol)
			end
		end
	end
end