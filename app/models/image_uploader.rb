class ImageUploader < ApplicationRecord
  has_many_attached :images
  validates :name, presence: , uniqueness: true

  validate :image_sizes, if: -> { images.attached? }

  private

  def image_sizes
    images.each do |image|
      if image.blob.byte_size < 50.kilobytes || image.blob.byte_size > 100.kilobytes
        errors.add(:images, 'each image must be between 50 and 100 KB')
      end
    end
  end
end
