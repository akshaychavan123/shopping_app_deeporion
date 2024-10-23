class UserNotification < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :resource_type, presence: true
  validates :resource_id, presence: true
  
  scope :unread, -> { where(read: false) }
end
