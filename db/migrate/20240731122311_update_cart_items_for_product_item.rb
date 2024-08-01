class UpdateCartItemsForProductItem < ActiveRecord::Migration[7.0]
  def change
    if index_exists?(:cart_items, :product_item_variant_id)
      remove_index :cart_items, :product_item_variant_id
    end

    # Remove the existing foreign key constraint on product_item_variant_id
    if foreign_key_exists?(:cart_items, column: :product_item_variant_id)
      remove_foreign_key :cart_items, column: :product_item_variant_id
    end

    # Remove the product_item_variant_id column
    remove_column :cart_items, :product_item_variant_id

    # Add the new product_item_id column and foreign key
    add_reference :cart_items, :product_item, null: false, foreign_key: true

    # Add an index on the new product_item_id column
    add_index :cart_items, :product_item_id unless index_exists?(:cart_items, :product_item_id)
  end
end
