class Addcolortoproductitem < ActiveRecord::Migration[7.0]
  def change
    add_column :product_items, :color, :string
  end
end
