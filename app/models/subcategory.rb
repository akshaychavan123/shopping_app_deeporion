class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :products, dependent: :destroy
  has_many :coupons, as: :couponable
end
