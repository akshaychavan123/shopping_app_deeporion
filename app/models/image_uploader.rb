class ImageUploader < ApplicationRecord
  has_many_attached :images
  validates :name, presence: , uniqueness: true
end
