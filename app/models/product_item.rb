class ProductItem < ApplicationRecord
  belongs_to :product
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :wishlist_items
  has_many :wishlists, through: :wishlist_items
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :reviews, dependent: :destroy
  has_many :product_item_variants, dependent: :destroy
  has_many :coupons, as: :couponable
  has_one_attached :image
  has_many_attached :photos

  validates :name, presence: true, on: :create
  validates :description, presence: true, on: :create
  validates :product_code, uniqueness: true, on: :create

  scope :new_arrivals, -> { order(created_at: :desc).limit(10) }
end