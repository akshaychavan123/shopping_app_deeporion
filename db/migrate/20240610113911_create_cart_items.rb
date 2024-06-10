class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product_item, null: false, foreign_key: true
      t.integer :quantity, default: 1
      t.decimal :total_price

      t.timestamps
    end
  end
end
