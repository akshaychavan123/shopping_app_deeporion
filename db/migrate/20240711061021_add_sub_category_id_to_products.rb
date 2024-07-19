class AddSubCategoryIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :subcategory_id, :bigint
    add_index :products, :subcategory_id
    add_foreign_key :products, :subcategories, column: :subcategory_id
  end
end
