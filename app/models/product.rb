class Product < ApplicationRecord
  belongs_to :subcategory
  has_many :product_items
  validates :name, presence: true
end
