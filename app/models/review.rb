class Review < ApplicationRecord
  belongs_to :product_item
  belongs_to :user
  has_many :review_votes, dependent: :destroy
  has_many_attached :images_and_videos

  validates :star, presence: true
  validates :recommended, inclusion: { in: [true, false] }
  validates :review, presence: true
end
