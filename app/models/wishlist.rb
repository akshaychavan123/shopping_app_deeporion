class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlist_items, dependent: :destroy
  has_many :product_items, through: :wishlist_items
  # has_many :product_item_variants, through: :wishlist_items
end
