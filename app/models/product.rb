class Product < ApplicationRecord
  belongs_to :category
  has_many :product_items
  has_one_attached :image
  validates :name, presence: true, uniqueness: { scope: :category_id }
  scope :top_category, -> { order(created_at: :desc).limit(10) }
end