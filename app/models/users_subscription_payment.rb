class UsersSubscriptionPayment < ApplicationRecord
	belongs_to	:users_subscription, optional: true
	after_create	:regenerate_income_report

	def self.initial_price_to_pay(subscription_option, session_discount_code=nil)
		if session_discount_code.present?
			DiscountCode.apply_discount_code_to_option(session_discount_code, subscription_option).discounted_price
		else
			subscription_option.price
		end
	end

	def user
		self.users_subscription.user.full_name
	end

	def processed_at
		self.paid_at.strftime("%H:%M on %B %d, %Y")
	end

	def author_fee
		if author = users_subscription.user.subscription_referring_author
			percentage = author.subscription_fee_split.to_i
			if percentage > 0
				"%.2f" % (amount * (percentage.to_f / 100))
			else
				0
			end
		end
	end

	def author_name
		users_subscription.user.subscription_referring_author_name
	end

  def regenerate_income_report
  	report = IncomeReport.find_or_create_for_current_month
  	report.generate_stats
  end
end