class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  # belongs_to :product_item
  belongs_to :product_item_variant
  validates :product_item_variant_id, uniqueness: { scope: :wishlist_id, message: 'has already been added to the wishlist' }
end
