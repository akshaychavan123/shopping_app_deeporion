class Category < ApplicationRecord
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :parent_id }
end
