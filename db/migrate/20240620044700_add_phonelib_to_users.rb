class AddPhonelibToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_phone_number, :string
    add_column :users, :country_code, :string
    add_column :users, :phone_verification_code_sent_at, :datetime
  end
end
