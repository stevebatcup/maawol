class BasketItem < ApplicationRecord
  acts_as_shopping_cart_item_for :basket
end