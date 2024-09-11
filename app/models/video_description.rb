class VideoDescription < ApplicationRecord
  has_many :video_libraries, dependent: :destroy
  validates :description, presence: true
end
