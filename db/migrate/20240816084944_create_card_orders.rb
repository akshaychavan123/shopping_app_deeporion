class CreateCardOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :card_orders do |t|
      t.references :gift_card, null: false, foreign_key: true
      t.string :recipient_name
      t.string :recipient_email
      t.date :dob
      t.string :sender_email
      t.text :message
      t.decimal :price

      t.timestamps
    end
  end
end
