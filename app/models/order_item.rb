class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product_item
  has_many :returns, dependent: :destroy
  belongs_to :product_item_variant, optional: true

  validates :product_item_id, presence: true
  validates :product_item_variant_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum return_status: {
    not_returned: 0,
    return_requested: 1,
    return_approved: 2,
    return_rejected: 3,
    refund_issued: 4,
  }

  enum status: {
    pending: 'pending',
    out_for_delivery: 'out_for_delivery',
    delivered: 'delivered',
    cancelled: 'cancelled',
    returned: 'returned'
  }, _default: 'pending'

end

