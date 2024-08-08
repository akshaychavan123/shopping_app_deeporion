class Category < ApplicationRecord
  has_many :subcategories, dependent: :destroy
  has_many :products, through: :subcategories
  has_many :coupons, as: :couponable
  validates :name, presence: true, uniqueness: true
end
