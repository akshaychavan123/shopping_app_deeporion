class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :payment_id, null: false
      t.string :order_id, null: false
      t.string :signature
      t.string :status, null: false, default: 'pending'
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true

      t.timestamps
    end
    add_index :payments, :payment_id, unique: true
    add_index :payments, :order_id
  end
end
