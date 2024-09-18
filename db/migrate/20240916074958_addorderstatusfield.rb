class Addorderstatusfield < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :status, :string, default: "pending"
  end
end
