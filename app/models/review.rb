class Review < ApplicationRecord
  belongs_to :product_item
  belongs_to :user
  has_many :review_votes, dependent: :destroy
  has_many_attached :images
  has_many_attached :videos

  validates :star, presence: true
  validates :review, presence: true

  validate :image_size_validation
  validate :video_size_validation

  scope :active, -> { where(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.current)
  end

  private

  def image_size_validation
    return unless images.attached?

    images.each do |image|
      if image.blob.byte_size > 100.kilobytes 
        errors.add(:images, "each must be up to 100 KB")
      end
    end
  end

  def video_size_validation
    return unless videos.attached?

    videos.each do |video|
      if video.blob.byte_size > 1.megabyte
        errors.add(:videos, "each must be up to 1 MB")
      end
    end
  end
end
