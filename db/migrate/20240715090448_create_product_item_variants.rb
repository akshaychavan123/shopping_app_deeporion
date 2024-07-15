class CreateProductItemVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :product_item_variants do |t|
      t.string :color
      t.string :size
      t.decimal :price
      t.integer :quantity
      t.references :product_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
