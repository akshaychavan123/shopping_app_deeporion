class AddCouponIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :coupon_id, :bigint, null: true
    add_index :orders, :coupon_id
    add_foreign_key :orders, :coupons
  end
end
