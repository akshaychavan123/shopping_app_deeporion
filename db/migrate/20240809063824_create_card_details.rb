class CreateCardDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :card_details do |t|
      t.string :holder_name
      t.string :card_number
      t.string :expiry_date
      t.string :cvv
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
