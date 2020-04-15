FactoryBot.define do
  factory :product_payment do
  	product_id { 1 }
    amount { 5.00 }
    status { 'paid' }
    payment_system { 'paypal' }
    email { 'steve@foo.com' }
    first_name { 'Steve' }
    last_name	{ 'Foocup' }
    created_at { Time.now }

    after(:create) do |payment|
      payment.class.skip_callback(:create, :after, :regenerate_income_report, raise: false)
    end
  end

  factory :users_subscription_payment do
    users_subscription_id { 1 }
    amount { 25.00 }
    status { 'paid' }
    created_at { Time.now }

    after(:create) do |payment|
      payment.class.skip_callback(:create, :after, :regenerate_income_report, raise: false)
    end
  end
end
