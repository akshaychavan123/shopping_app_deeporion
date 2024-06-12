class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :product_items, through: :order_items

  accepts_nested_attributes_for :order_items



  validates :user_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :country, presence: true
  validates :pincode, presence: true, numericality: { only_integer: true }, length: { is: 6 }
  validates :area, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :address, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :address_type, presence: true, inclusion: { in: %w(Home Work), message: "%{value} is not a valid address type" }
  # validates :payment_status, presence: true, inclusion: { in: %w(pending paid failed), message: "%{value} is not a valid payment status" }
  validates :order_number, presence: true, uniqueness: true
  validates :placed_at, presence: true

  before_validation :generate_order_number, on: :create

  private

  def generate_order_number
    self.order_number = "ORD#{SecureRandom.hex(10).upcase}" if order_number.blank?
  end
end
