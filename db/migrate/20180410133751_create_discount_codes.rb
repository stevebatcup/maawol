class CreateDiscountCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_codes do |t|
    	t.string   :code
    	t.datetime :valid_from
    	t.datetime :valid_to
    	t.integer  :use_count
    	t.integer  :redemption_count

      t.timestamps
    end
  end
end
