class AddParentIdToCategories < ActiveRecord::Migration[7.0]
  def up
    add_column :categories, :parent_id, :integer
    add_index :categories, :parent_id
  end

  def down
    remove_index :categories, :parent_id
    remove_column :categories, :parent_id
  end  
end
