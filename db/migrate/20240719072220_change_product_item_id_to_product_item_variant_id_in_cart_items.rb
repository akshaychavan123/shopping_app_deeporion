class ChangeProductItemIdToProductItemVariantIdInCartItems < ActiveRecord::Migration[7.0]
  def change
    remove_index :cart_items, :product_item_id
    rename_column :cart_items, :product_item_id, :product_item_variant_id
    add_index :cart_items, :product_item_variant_id
    change_column_default :cart_items, :quantity, from: nil, to: 1
  end
end
