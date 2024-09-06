class Addfieldtoproductitemvariants < ActiveRecord::Migration[7.0]
  def change
    add_column :product_item_variants, :in_stock, :boolean
  end
end
