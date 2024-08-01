class AddProductItemIdToWishlistItems < ActiveRecord::Migration[7.0]
  def change
    remove_reference :wishlist_items, :product_item_variant, foreign_key: true
    add_reference :wishlist_items, :product_item, foreign_key: true
  end
end
