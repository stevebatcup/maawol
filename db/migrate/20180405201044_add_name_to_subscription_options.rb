class AddNameToSubscriptionOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscription_options, :name, :string
  end
end
