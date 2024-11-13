class Addfieldtocontactus < ActiveRecord::Migration[7.0]
  def change
    add_column :contact_us, :status, :string
    add_column :contact_us, :comment, :string
  end
end
