class CreateSubscriptionOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscription_options do |t|
      t.integer :days
      t.integer :months
      t.string :level
      t.string :status
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :display_sort
      t.text :description
      t.string :tag
      t.integer :payment_system_plan_id
    end
  end
end
