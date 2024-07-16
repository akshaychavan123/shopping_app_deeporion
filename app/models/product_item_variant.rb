class ProductItemVariant < ApplicationRecord
  belongs_to :product_item
  has_many :wishlist_items
  has_many_attached :photos

  validates :color, presence: true, length: { maximum: 255 }
  validates :size, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # validate :unique_color_size_combination

  # private

  # def unique_color_size_combination
  #   if ProductItemVariant.exists?(product_item_id: product_item_id, color: color, size: size)
  #     errors.add(:base, 'A variant with the same color and size already exists for this product item')
  #   end
  # end
end
