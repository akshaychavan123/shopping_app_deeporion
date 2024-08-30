class AddDetailsToOrderItems < ActiveRecord::Migration[7.0]
  def change
    remove_reference :order_items, :cart_item, index: true, foreign_key: true

    add_column :order_items, :product_item_id, :bigint, null: false
    add_column :order_items, :product_item_variant_id, :bigint
    add_column :order_items, :quantity, :integer, null: false, default: 1
    add_column :order_items, :total_price, :decimal, null: false
  end
end
