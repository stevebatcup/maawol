class SortUsersSubscriptionFields < ActiveRecord::Migration[5.0]
  def change
  	remove_column	:users_subscriptions, :order_id, :integer
  	remove_column	:users_subscriptions, :paypal_billing_agreement_id, :integer
  	add_column	:users_subscriptions, :payment_system, :string
  end
end
