class Basket < ApplicationRecord
  acts_as_shopping_cart_using :basket_item

  def taxes
		0
  end

  def shipping_cost
  	0
  end
end