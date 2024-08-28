class UpdateOrdersAddAddressReference < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :address, foreign_key: true
    add_column :orders, :razorpay_order_id, :string
    add_column :orders, :razorpay_payment_id, :string

    remove_column :orders, :first_name, :string
    remove_column :orders, :last_name, :string
    remove_column :orders, :phone_number, :string
    remove_column :orders, :email, :string
    remove_column :orders, :country, :string
    remove_column :orders, :pincode, :string
    remove_column :orders, :area, :string
    remove_column :orders, :city, :string
    remove_column :orders, :state, :string
    remove_column :orders, :address, :text
    remove_column :orders, :address_type, :string
    remove_column :orders, :placed_at, :datetime
  end
end
