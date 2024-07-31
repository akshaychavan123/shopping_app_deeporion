class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product_item
  # delegate :product_item, to: :product_item_variant
end
