class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_items, dependent: :destroy

  accepts_nested_attributes_for :order_items
  validates :user_id, presence: true
  validates :address_id, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :payment_status, presence: true, inclusion: { in: %w(pending paid failed), message: "%{value} is not a valid payment status" }
  validates :receipt_number, presence: true, uniqueness: true

  enum status: {
    created: 'created',
    paid: 'paid',
    shipped: 'shipped',
    delivered: 'delivered',
    canceled: 'canceled',
    returned: 'returned',
    refunded: 'refunded'
  }

end
