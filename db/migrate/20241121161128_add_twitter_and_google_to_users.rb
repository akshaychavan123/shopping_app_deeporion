class AddTwitterAndGoogleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :twitter, :string
    add_column :users, :google, :string
  end
end
