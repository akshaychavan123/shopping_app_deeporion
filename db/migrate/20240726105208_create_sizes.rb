class CreateSizes < ActiveRecord::Migration[7.0]
  def change
    create_table :sizes do |t|
      t.string :size_name
      t.decimal :price
      t.integer :quantity
      t.references :product_item_variant, null: false, foreign_key: true

      t.timestamps
    end
    add_index :sizes, [:size_name, :product_item_variant_id], unique: true
  end
end
