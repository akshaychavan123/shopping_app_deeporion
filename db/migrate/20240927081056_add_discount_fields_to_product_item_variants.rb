class AddDiscountFieldsToProductItemVariants < ActiveRecord::Migration[7.0]
  def change
    add_column :product_item_variants, :discounted_price, :decimal
    add_column :product_item_variants, :discount_percent, :decimal
  end
end
