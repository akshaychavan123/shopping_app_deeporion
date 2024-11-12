class ClientReview < ApplicationRecord
  belongs_to :user
  has_one :client_review_comment, dependent: :destroy

  validates :star, presence: true, inclusion: { in: [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5], message: "%{value} is not a valid star rating" }
  validates :review, presence: true

  scope :active, -> { where(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.current)
  end
end
