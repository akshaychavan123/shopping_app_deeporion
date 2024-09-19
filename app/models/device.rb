class Device < ApplicationRecord
  require 'fcm'
  require 'json'

  belongs_to :user
  validates :device_token, presence: true, uniqueness: { scope: :user_id }
end
