class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product_item
end
