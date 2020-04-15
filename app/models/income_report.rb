class IncomeReport < ApplicationRecord
	validate	:one_per_month, on: :create
	validate	:cannot_update_old, on: :update
	enum	status: [:unpaid, :paid, :deleted]

	def one_per_month
		if self.class.find_by(month: self.month)
			self.errors[:base] << "Sorry, you cannot create multiple reports for one month"
		end
	end

	def cannot_update_old
		if self.month != self.class.current_month
			self.errors[:base] << "Sorry, you cannot update an old report"
		end
	end

	def month_and_year
		"#{Date::MONTHNAMES[self.month]} #{self.year}"
	end

	def generate_stats
		self.store_payments_count = store_payments.size
		self.store_payments_total = build_store_payments_total
		self.subscription_payments_count = subscription_payments.size
		self.subscription_payments_total = build_subscription_payments_total
		self.total_income = build_store_payments_total + build_subscription_payments_total
		self.earnings = build_earnings
		self.save
	end

	def build_earnings
		(self.total_income * (self.profit_split_percentage.to_f / 100 ))
	end

	def self.find_or_create_for_current_month
		unless report = find_by(month: current_month)
			report = self.create({
				month: current_month,
				year: current_year,
				status: :unpaid,
				profit_split_percentage: SiteSetting.get_profit_split_percentage
			})
		end
		report.generate_stats
		report
	end

private

	def store_payments
		@store_payments ||= begin
			ProductPayment.where(status: :paid)
				.where("#{self.class.current_month} = date_part('month', created_at) AND #{self.class.current_year} = date_part('year', created_at)")
		end
	end

	def build_store_payments_total
		@build_store_payments_total ||= store_payments.map(&:amount).sum
	end

	def subscription_payments
		@subscription_payments ||= begin
			UsersSubscriptionPayment.where(status: :paid)
				.where("#{self.class.current_month} = date_part('month', created_at) AND #{self.class.current_year} = date_part('year', created_at)")
		end
	end

	def build_subscription_payments_total
		@build_subscription_payments_total ||= subscription_payments.map(&:amount).sum
	end

	def self.current_month
		Date.today.month
	end

	def self.current_year
		Date.today.year
	end
end
