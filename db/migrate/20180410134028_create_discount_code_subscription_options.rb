class CreateDiscountCodeSubscriptionOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_code_subscription_options do |t|
	    t.integer :discount_code_id
	    t.integer :subscription_option_id
	    t.string  :discount_type
	    t.string  :discount_value
	    t.integer :display_sort

      t.timestamps
    end
  end
end
