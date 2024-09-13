class GiftCardCategory < ApplicationRecord
  has_many :gift_cards
  has_one_attached :image
  validates :title, presence: true
end
