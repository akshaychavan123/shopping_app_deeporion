class AddPhoneDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone_confirmed, :boolean
    add_column :users, :phone_number, :string
    add_column :users, :phone_verification_code, :string
  end
end
