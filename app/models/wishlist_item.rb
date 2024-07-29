class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  belongs_to :product_item
  belongs_to :product_item
  validates :product_item_id, uniqueness: { scope: :wishlist_id, message: 'has already been added to the wishlist' }
end