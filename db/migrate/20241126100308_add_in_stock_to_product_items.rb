class AddInStockToProductItems < ActiveRecord::Migration[7.0]
  def change
    add_column :product_items, :in_stock, :boolean, default: false, null: false
  end
end
