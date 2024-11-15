class Review < ApplicationRecord
  belongs_to :product_item
  belongs_to :user
  has_many :review_votes, dependent: :destroy
  has_many_attached :images_and_videos

  validates :star, presence: true
  validates :review, presence: true

  scope :active, -> { where(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.current)
  end
end
