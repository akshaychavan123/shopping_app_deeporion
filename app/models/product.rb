class Product < ApplicationRecord
  belongs_to :subcategory
  has_many :product_items
  has_many :coupons, as: :couponable
  validates :name, presence: true, uniqueness: { scope: :subcategory_id }
end
