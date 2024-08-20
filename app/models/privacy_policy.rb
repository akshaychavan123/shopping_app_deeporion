class PrivacyPolicy < ApplicationRecord
  validates :heading, presence: true, length: { maximum: 255 }
  validates :description, presence: true
end
