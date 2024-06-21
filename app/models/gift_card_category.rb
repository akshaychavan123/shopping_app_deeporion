class GiftCardCategory < ApplicationRecord
  has_many :gift_cards
  validates :title, presence: true
end
