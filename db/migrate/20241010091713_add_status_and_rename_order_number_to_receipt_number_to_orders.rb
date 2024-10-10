class AddStatusAndRenameOrderNumberToReceiptNumberToOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :order_number, :string
    add_column :orders, :status, :string
    add_column :orders, :receipt_number, :string
  end
end
