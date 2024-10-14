class AddDiscountFieldsToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :discount_type, :string
    add_column :coupons, :max_purchase, :decimal
  end
end
