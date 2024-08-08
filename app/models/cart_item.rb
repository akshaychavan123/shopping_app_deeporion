class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product_item
  belongs_to :product_item_variant, optional: true
  validates :product_item_id, uniqueness: { scope: :cart_id, message: "is already in the cart" }
  # delegate :product_item, to: :product_item_variant
end
