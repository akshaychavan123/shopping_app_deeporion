class DropSubcategoriesTable < ActiveRecord::Migration[7.0]
  def up
    Product.where.not(subcategory_id: nil).destroy_all
    remove_foreign_key :products, :subcategories
    remove_reference :products, :subcategory, index: true

    drop_table :subcategories
  end

  def down
    create_table :subcategories do |t|
      t.string :name
      t.bigint :category_id, null: false
      t.timestamps
    end
    add_index :subcategories, :category_id

    add_reference :products, :subcategory, foreign_key: true
  end
end
