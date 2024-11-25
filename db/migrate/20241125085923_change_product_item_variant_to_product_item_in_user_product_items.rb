class ChangeProductItemVariantToProductItemInUserProductItems < ActiveRecord::Migration[7.0]
  def change
    remove_reference :user_product_items, :product_item_variant, index: true, foreign_key: true
    add_reference :user_product_items, :product_item, null: false, foreign_key: true
  end
end
