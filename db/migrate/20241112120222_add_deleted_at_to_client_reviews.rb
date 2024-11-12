class AddDeletedAtToClientReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :client_reviews, :deleted_at, :datetime
    add_index :client_reviews, :deleted_at
  end
end
