class CreateClientReviewComments < ActiveRecord::Migration[7.0]
  def change
    create_table :client_review_comments do |t|
      t.references :client_review, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
