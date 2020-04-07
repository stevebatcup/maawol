require 'acts_as_shopping_cart'
class CreateBasketTable < ActiveRecord::Migration[5.2]
  def change
  	create_table :baskets do |t|
  		t.timestamps
  	end

    create_table :basket_items do |t|
    	t.shopping_cart_item_fields # Creates the cart items fields
    	t.timestamps
    end

    add_index :basket_items, [:owner_id, :owner_type]
  end
end
