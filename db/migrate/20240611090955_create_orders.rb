class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :country
      t.string :pincode
      t.string :area
      t.string :city
      t.string :state
      t.text :address
      t.decimal :total_price
      t.string :address_type
      t.string :payment_status
      t.string :order_number
      t.datetime :placed_at


      t.timestamps
    end
  end
end
  