class ProductItem < ApplicationRecord
  belongs_to :product
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :wishlist_items
  has_many :wishlists, through: :wishlist_items

  # has_many :wishlist_items, through: :product_item_variants
  # has_many :wishlists, through: :wishlist_items
  has_many :cart_items
  has_many :carts, through: :cart_items
  has_many :reviews, dependent: :destroy
  has_many :product_item_variants
  has_many :coupons, as: :couponable
  has_one_attached :image
  has_many_attached :photos

  validates :name, presence: true
  validates :description, presence: true
  validates :product_code, uniqueness: true

  scope :new_arrivals, -> { order(created_at: :desc).limit(10) }
end