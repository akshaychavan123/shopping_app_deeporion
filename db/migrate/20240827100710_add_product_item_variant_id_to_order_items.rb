class AddProductItemVariantIdToOrderItems < ActiveRecord::Migration[7.0]
  def change
    change_table :order_items do |t|
      t.remove :product_item_id, :sub_total, :quantity if column_exists?(:order_items, :product_item_id)
      
      t.references :cart_item, null: false, foreign_key: true unless column_exists?(:order_items, :cart_item_id)

      unless index_exists?(:order_items, :cart_item_id)
        t.index :cart_item_id
      end
    end
  end
end
