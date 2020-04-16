json.set! :subscriptionOption do
	json.months @option.months
	json.name pluralize @option.months, t('views.defaults.month_singular')
	json.monthsText pluralize @option.months, t('views.defaults.month_singular')
	if @option.discounted_by
		json.saving @option.saving_percentage(true, @option.discounted_by.to_i)
	else
		json.saving @option.saving_percentage(true)
	end
	json.monthlyPrice @option.monthly_price
	json.monthlyPriceFullText "#{@option.monthly_price(Maawol::Config.currency_symbol, true)}<br /><span class='month'> / #{t('views.defaults.month_singular')}</span>"
	json.mostPopular @option.tag && @option.tag.to_sym == :most_popular
	json.fullPrice @option.price
	if @option.discounted_price
		json.price @option.discounted_price
	else
		json.price @option.price
	end
end