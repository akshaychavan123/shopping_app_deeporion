class AddDeletedAtToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :deleted_at, :datetime
    add_index :reviews, :deleted_at
  end
end
