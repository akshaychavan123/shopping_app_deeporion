class CreateGiftCards < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_cards do |t|
      t.string :image
      t.decimal :price
      t.integer :gift_card_category_id

      t.timestamps
    end
  end
end
