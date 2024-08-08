class ReviewVote < ApplicationRecord
  belongs_to :review
  belongs_to :user
  validates :helpful, inclusion: { in: [true, false] }

  validates :user_id, uniqueness: { scope: :review_id, message: 'can only vote once per review' }
end
