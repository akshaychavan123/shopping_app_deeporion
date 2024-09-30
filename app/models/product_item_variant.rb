class ProductItemVariant < ApplicationRecord
  belongs_to :product_item
  belongs_to :cart_item, optional: true
  has_many :coupons, as: :couponable
  
  validates :size, presence: true, uniqueness: { scope: :product_item_id }, on: :create
  validates :quantity, presence: true, on: :create
end

