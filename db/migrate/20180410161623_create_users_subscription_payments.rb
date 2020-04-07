class CreateUsersSubscriptionPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :users_subscription_payments do |t|
			t.integer  :users_subscription_id
			t.string   :notification_id
			t.decimal  :amount, precision: 8, scale: 2
			t.string   :status
			t.datetime :paid_at
			t.boolean  :first_payment

      t.timestamps
    end
  end
end
