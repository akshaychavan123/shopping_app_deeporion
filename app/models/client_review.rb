class ClientReview < ApplicationRecord
  belongs_to :user

  validates :star, presence: true, inclusion: { in: [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5], message: "%{value} is not a valid star rating" }
  validates :review, presence: true
end
