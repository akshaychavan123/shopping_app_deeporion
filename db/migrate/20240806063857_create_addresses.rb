class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :country
      t.string :pincode
      t.string :area
      t.string :state
      t.string :address
      t.string :city
      t.string :address_type
      t.boolean :default
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
