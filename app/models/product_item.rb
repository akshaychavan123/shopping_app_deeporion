class ProductItem < ApplicationRecord
  belongs_to :product
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :wishlist_items
  has_many :wishlists, through: :wishlist_items
  has_many :cart_items
  has_many :carts, through: :cart_items
  has_many :reviews
  has_many_attached :images


  validates :name, presence: true
  validates :brand, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :discounted_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :description, presence: true
  # validates :size, presence: true, inclusion: { in: %w(XS S M L XL XXL), message: "%{value} is not a valid size" }
  validates :material, presence: true
  validates :care, presence: true
  # validates :product_code, presence: true, uniqueness: true
end