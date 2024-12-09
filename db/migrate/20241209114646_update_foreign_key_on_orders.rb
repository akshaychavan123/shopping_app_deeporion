class UpdateForeignKeyOnOrders < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :orders, :addresses 
    add_foreign_key :orders, :addresses, column: :address_id, on_delete: :nullify
  end
end
