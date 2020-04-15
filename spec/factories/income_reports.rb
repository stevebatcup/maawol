FactoryBot.define do
  factory :income_report do
    month { Date.today.month }
    year { Date.today.year }
    subscription_payments_count { 5 }
    subscription_payments_total { 10.99 }
    store_payments_count { 2 }
    store_payments_total { 23.60 }
    total_income { 34.59 }
    profit_split_percentage { 80 }
    earnings { 27.67 }
    status { :unpaid }
    payment_notes { nil }
    paid_on { nil }
  end
end
