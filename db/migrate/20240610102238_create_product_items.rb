class CreateProductItems < ActiveRecord::Migration[7.0]
  def change
    create_table :product_items do |t|
      t.integer :product_id
      t.string :name
      t.string :brand
      t.decimal :price
      t.decimal :discounted_price
      t.text :description
      t.string :size
      t.string :material
      t.string :care
      t.string :product_code

      t.timestamps
    end
  end
end
