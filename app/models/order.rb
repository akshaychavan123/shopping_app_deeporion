class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_items

  accepts_nested_attributes_for :order_items
  validates :user_id, presence: true
  validates :address_id, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :payment_status, presence: true, inclusion: { in: %w(pending paid failed), message: "%{value} is not a valid payment status" }
  validates :order_number, presence: true, uniqueness: true
  validates :placed_at, presence: true

  before_validation :generate_order_number, on: :create

  private

  def generate_order_number
    self.order_number = "ORD#{SecureRandom.hex(10).upcase}" if order_number.blank?
  end
end
