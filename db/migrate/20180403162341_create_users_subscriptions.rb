class CreateUsersSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :users_subscriptions do |t|
    	t.integer :user_id
    	t.string :status
    	t.integer :subscription_option_id
    	t.integer :order_id
    	t.datetime :ends_at
    	t.string :payment_system_id
    	t.integer :successful_recurring_payments

    	t.decimal :initial_price, :precision => 8, :scale => 2
    	t.string :cancellation_reason
    	t.datetime :starts_at
    	t.integer :discount_code_id


    	t.timestamps null: false
    end
  end
end
