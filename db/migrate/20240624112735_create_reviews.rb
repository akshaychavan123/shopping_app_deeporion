class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :star
      t.boolean :recommended
      t.text :review
      t.references :user, null: false, foreign_key: true
      t.references :product_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
