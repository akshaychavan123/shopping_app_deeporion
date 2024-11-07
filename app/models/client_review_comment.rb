class ClientReviewComment < ApplicationRecord
  belongs_to :client_review
  belongs_to :user
  validates :comment, presence: true
end
