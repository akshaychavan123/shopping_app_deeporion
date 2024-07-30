class ProductItemVariant < ApplicationRecord
  belongs_to :product_item
  has_many :wishlist_items, dependent: :destroy
  has_many_attached :photos
  has_many :cart_items
  has_many :coupons, as: :couponable
  has_many :sizes, dependent: :destroy

  validates :color, presence: true, uniqueness: { scope: :product_item_id }
  # validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  accepts_nested_attributes_for :sizes, allow_destroy: true
  scope :new_arrivals, -> { order(created_at: :desc).limit(10) }

  # validate :unique_color_size_combination

  # private

  # def unique_color_size_combination
  #   if ProductItemVariant.exists?(product_item_id: product_item_id, color: color, size: size)
  #     errors.add(:base, 'A variant with the same color and size already exists for this product item')
  #   end
  # end
end
