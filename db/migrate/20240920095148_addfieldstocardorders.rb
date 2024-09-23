class Addfieldstocardorders < ActiveRecord::Migration[7.0]
  def change
    add_column :card_orders, :razorpay_order_id, :string
    add_column :card_orders, :razorpay_payment_id, :string
    add_column :card_orders, :payment_status, :string
    add_column :card_orders, :order_status, :string
  end
end
