class Addfieldheighttoproductitems < ActiveRecord::Migration[7.0]
  def change
    add_column :product_items, :height, :string
  end
end
