class AddColumnToProductItem < ActiveRecord::Migration[7.0]
  def change
    add_column :product_items, :care_instructions, :text
    add_column :product_items, :fabric, :string
    add_column :product_items, :hemline, :string
    add_column :product_items, :neck, :string
    add_column :product_items, :texttile_thread, :string
    add_column :product_items, :size_and_fit, :text
    add_column :product_items, :main_trend, :string
    add_column :product_items, :knite_or_woven, :string
    add_column :product_items, :length, :string
    add_column :product_items, :occasion, :string
  end
end
