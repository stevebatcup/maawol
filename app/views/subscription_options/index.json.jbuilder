json.set! :subscriptionOptions do
	json.array! @options do |option|
		json.level option.level
		json.name option.name
		json.price option.price
		json.fullPrice option.price
		json.monthsText pluralize option.months, "month"
		json.monthlyPrice option.monthly_price
		json.monthlyPriceFullText subscription_option_full_text(option)
		json.mostPopular option.tag && option.tag.to_sym == :most_popular
		json.discountedPrice 0
		json.discountedPercentage 0
		json.description option.description
	end
end
json.selectedLevel @selectedLevel