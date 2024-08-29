class ProductItemVariant < ApplicationRecord
  belongs_to :product_item
  belongs_to :cart_item, optional: true
  has_many :coupons, as: :couponable
  
  validates :size, presence: true
  validates :quantity, presence: true
end
