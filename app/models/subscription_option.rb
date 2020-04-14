class SubscriptionOption < ApplicationRecord
	attr_accessor	:discounted_price, :discounted_by, :extra_months
	default_scope { where(status: :active) }
	before_save :set_months

	def set_months
		self.months = (days / 30).ceil if months.nil?
	end

	def monthly_price(currency=false, small_pence=false)
		field = self.discounted_price.nil? ? :price : :discounted_price
		amount = '%.2f' % (self.send(field) / self.months)
		amount = currency != false ? "#{currency}#{amount}".html_safe : amount
		if small_pence != false
			dot_index = amount.to_s.index('.')
			pence = amount[dot_index, amount.length]
			pence_html = "<span class='pence'>#{pence}</span>"
			amount[dot_index, amount.length] = pence_html.html_safe
		end
		amount
	end

	def yearly_price(currency=false, small_pence=false)
		field = self.discounted_price.nil? ? :price : :discounted_price
		amount = '%.2f' % self.send(field)
		amount = currency != false ? "#{currency}#{amount}".html_safe : amount
		if small_pence != false
			dot_index = amount.to_s.index('.')
			pence = amount[dot_index, amount.length]
			pence_html = "<span class='pence'>#{pence}</span>"
			amount[dot_index, amount.length] = pence_html.html_safe
		end
		amount
	end
end