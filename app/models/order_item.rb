class OrderItem < ApplicationRecord
  belongs_to :order

  validates :product_item_id, presence: true
  validates :product_item_variant_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
