class CreateUserProductItems < ActiveRecord::Migration[7.0]
  def change
    create_table :user_product_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product_item_variant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
