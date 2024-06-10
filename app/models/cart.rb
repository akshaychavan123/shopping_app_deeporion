class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :product_items, through: :cart_items

  validates :user_id, presence: true
end
