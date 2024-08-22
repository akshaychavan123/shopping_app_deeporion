class CreateClientReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :client_reviews do |t|
      t.float :star
      t.text :review
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
