class GiftCard < ApplicationRecord
  belongs_to :gift_card_category
  has_many_attached :images
  validates :price, presence: true
end
