json.status @status
json.message @message if @message
if @discount
	json.set! :discount do
		json.code @discount.code
		json.subscriptionOptions @discount.discounted_options do |option|
			json.level option.level
			json.name option.name
			json.description option.description
			json.months option.months
			json.monthsText pluralize option.months, 'month'
			json.discounted_by option.discounted_by.to_i
			json.monthlyPrice option.monthly_price
			json.monthlyPriceFullText "#{option.monthly_price("<span class='currency'>&dollar;</span>", true)}<span class='month'> / month</span>"
			json.mostPopular option.tag && option.tag.to_sym == :most_popular
			json.fullPrice option.price
			if option.discounted_price
				json.price number_with_precision(option.discounted_price, precision: 2)
				json.discountedPrice option.price - option.discounted_price
				json.discountedPercentage option.discounted_by
			else
				json.price number_with_precision(option.price, precision: 2)
			end

		end
	end
end