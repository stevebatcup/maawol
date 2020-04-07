class ChangeChargebeeIdFields < ActiveRecord::Migration[5.0]
  def change
  	remove_column	:users_subscriptions, :payment_system_id, :string
  	add_column	:users_subscriptions, :remote_customer_id, :string
  	add_column	:users_subscriptions, :remote_subscription_id, :string
    add_column :users_subscriptions, :next_payment_due_at, :datetime

  	add_index :users_subscriptions, :remote_customer_id
  end
end
