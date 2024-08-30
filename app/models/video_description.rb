class VideoDescription < ApplicationRecord
  has_many :video_libraries
  validates :description, presence: true
end
