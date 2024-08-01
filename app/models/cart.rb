class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :product_item, through: :cart_items
  # has_many :product_items, through: :product_item_variants
end
