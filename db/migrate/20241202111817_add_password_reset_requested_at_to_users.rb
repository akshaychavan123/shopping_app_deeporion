class AddPasswordResetRequestedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_reset_requested_at, :datetime
  end
end
