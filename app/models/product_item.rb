class ProductItem < ApplicationRecord
  belongs_to :product
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :wishlist_items
  has_many :wishlists, through: :wishlist_items
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :reviews, dependent: :destroy
  has_many :product_item_variants, dependent: :destroy
  has_many :coupons, as: :couponable
  has_one_attached :image
  has_many_attached :photos
  has_many :order_items, dependent: :destroy
  has_many :user_product_items, dependent: :destroy

  validates :name, presence: true, on: :create
  validates :description, presence: true, on: :create
  validates :product_code, uniqueness: true, on: :create

  validate :image_size_validation
  validate :photos_size_validation

  scope :new_arrivals, -> { order(created_at: :desc).limit(10) }

  private

  def image_size_validation
    return unless image.attached?

    if image.blob.byte_size < 50.kilobytes || image.blob.byte_size > 100.kilobytes
      errors.add(:image, ' image must be between 50 KB and 100 KB')
    end
  end

  def photos_size_validation
    photos.each do |photo|
      if photo.blob.byte_size < 50.kilobytes || photo.blob.byte_size > 100.kilobytes
        errors.add(:photos, 'each photos must be between 50 KB and 100 KB')
      end
    end
  end
end