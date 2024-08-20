class GiftCard < ApplicationRecord
  belongs_to :gift_card_category
  has_many_attached :images
  has_many :card_orders
  validates :price, presence: true
end
