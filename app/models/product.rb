class Product < ApplicationRecord
	has_many :product_items
	validates :name, presence: true
end
