class Review < ApplicationRecord
  belongs_to :product_item
  belongs_to :user
  has_many :review_votes, dependent: :destroy

  validates :star, presence: true
  validates :recommended, inclusion: { in: [true, false] }
  validates :review, presence: true
end
