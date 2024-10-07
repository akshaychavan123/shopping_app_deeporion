class ProductItemVariant < ApplicationRecord
  belongs_to :product_item
  belongs_to :cart_item, optional: true
  has_many :coupons, as: :couponable
  
  validates :size, presence: true, uniqueness: { scope: :product_item_id }, on: :create
  validates :quantity, presence: true, on: :create

  after_create :set_discounted_price

  private

  def set_discounted_price
    if discounted_price.nil?
      update(discounted_price: price)
    end
  end
end

