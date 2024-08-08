class AddProductItemVariantIdToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :cart_items, :product_item_variant, foreign_key: true, optional: true
  end
end
