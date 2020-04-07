class EditPaymentSystemPlanForSubscriptionOptions < ActiveRecord::Migration[5.0]
  def change
  	remove_column	:subscription_options, :payment_system_plan_id, :integer
  	add_column	:subscription_options, :payment_system_plan, :string
  end
end
