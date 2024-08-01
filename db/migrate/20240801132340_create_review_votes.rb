class CreateReviewVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :review_votes do |t|
      t.references :review, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.boolean :helpful

      t.timestamps
    end
  end
end
