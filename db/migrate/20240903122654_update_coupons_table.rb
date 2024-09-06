class UpdateCouponsTable < ActiveRecord::Migration[7.0]
  def change
    remove_index :coupons, name: "index_coupons_on_couponable"
    remove_column :coupons, :couponable_type, :string, null: false
    remove_column :coupons, :couponable_id, :bigint, null: false
    add_column :coupons, :product_ids, :integer, array: true, default: []
  end
end
