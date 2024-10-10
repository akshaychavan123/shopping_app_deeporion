class Return < ApplicationRecord
  belongs_to :order
  belongs_to :order_item
  belongs_to :address

  validates :reason, presence: true
  validates :refund_amount, presence: true, numericality: { greater_than: 0 }
end
