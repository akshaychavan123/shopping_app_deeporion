class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :products, dependent: :destroy
  has_many :coupons, as: :couponable
  validates :name, presence: true, uniqueness: { scope: :category_id }
end
