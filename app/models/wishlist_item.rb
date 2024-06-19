class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  belongs_to :product_item
end
