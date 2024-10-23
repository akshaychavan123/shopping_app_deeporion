class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product_item
  has_many :returns, dependent: :destroy

  validates :product_item_id, presence: true
  validates :product_item_variant_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  enum return_status: { not_returned: 0, returned: 1 , canceled: 3}
  # validates :return_status, presence: true, inclusion: { in: return_statuses.keys }
end
