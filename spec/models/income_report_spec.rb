require 'rails_helper'

RSpec.describe IncomeReport, type: :model do
	let(:downloadable) { FactoryBot.build_stubbed(:downloadable) }
	let(:store) { FactoryBot.build_stubbed(:store) }
	let(:product) { FactoryBot.build_stubbed(:product, productable: downloadable, store: store) }

	let(:user) { FactoryBot.build_stubbed(:user) }
	let(:subscription_option) { FactoryBot.build_stubbed(:subscription_option) }
	let(:users_subscription) { FactoryBot.build_stubbed(:users_subscription, user: user, subscription_option: subscription_option) }

	def report
		@report ||= IncomeReport.find_or_create_for_current_month
	end

	def create_store_payments
	  5.times do
	    FactoryBot.create(:product_payment, amount: 3.00, product: product)
		end
	end

	def create_subs_payments
	  3.times do
	    FactoryBot.create(:users_subscription_payment, amount: 25.00, users_subscription_id: users_subscription.id)
		end
	end

	before(:all) do
		SiteSetting.create({name: "Owner profit split percentage", value: 75})
	end

  it "generates an unpaid monthly report when one does not exist for the current month" do
  	expect(report.month).to eq(Date.today.month)
  	expect(report.year).to eq(Date.today.year)
  end

  describe "accurately calculates the payment counts" do
  	specify do
  		create_store_payments
  		report.generate_stats
	  	expect(report.store_payments_count).to eq(5)
	  end

  	specify do
  		create_subs_payments
  		report.generate_stats
	  	expect(report.subscription_payments_count).to eq(3)
	  end
  end

  describe "accurately calculates the payments totals" do
  	specify do
  		create_store_payments
  		report.generate_stats
	  	expect(report.store_payments_total).to eq(15.00)
	  end

  	specify do
  		create_subs_payments
  		report.generate_stats
	  	expect(report.subscription_payments_total).to eq(75.00)
	  end
  end


  it "accurately calculates the total monthly income" do
		create_store_payments
		create_subs_payments
		report.generate_stats
		expect(report.total_income).to eq 90.00
  end

  it "accurately calculates the earnings total for the site owner" do
		create_store_payments
		create_subs_payments
		expect(report.earnings).to eq 67.50
  end

  it "updates the current monthly report when a new payment is created" do
  	ProductPayment.create({ amount: 3.00, product: product })
  	new_report = IncomeReport.find_or_create_for_current_month
  	expect(new_report.total_income).to eq 3.00
  end

  describe "validate" do
	  it "does not generate a monthly report when one already exists for the current month" do
	  	report
	  	second_report = IncomeReport.create({month: Date.today.month})
			expect(second_report.errors[:base].first).to include("cannot create multiple reports for one month")
	  end

  	it "cannot update a past report" do
  		old_report = IncomeReport.create({month: 50.days.ago.month})
  		old_report.earnings = 34.00
  		old_report.valid?
  		expect(old_report.errors[:base].first).to include("cannot update an old report")
  	end
  end

end
