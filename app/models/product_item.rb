class ProductItem < ApplicationRecord
  belongs_to :product
  has_many :order_items
  has_many :orders, through: :order_items
  # has_many :wishlist_items
  # has_many :wishlists, through: :wishlist_items

  has_many :wishlist_items, through: :product_item_variants
  has_many :wishlists, through: :wishlist_items
  has_many :cart_items, through: :product_item_variants
  has_many :carts, through: :cart_items
  has_many :reviews
  has_many :product_item_variants
  has_many :coupons, as: :couponable
  has_one_attached :image

  validates :name, presence: true
  validates :brand, presence: true
  validates :description, presence: true
  validates :material, presence: true
  validates :care, presence: true
  validates :product_code, presence: true, uniqueness: true
end