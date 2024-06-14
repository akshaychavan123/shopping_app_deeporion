class Product < ApplicationRecord
	belongs_to :subcategory, optional: true
	has_many :product_items
	validates :name, presence: true
end
