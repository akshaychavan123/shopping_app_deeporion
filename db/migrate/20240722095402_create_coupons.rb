class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :promo_code_name
      t.string :promo_code
      t.date :start_date
      t.date :end_date
      t.integer :max_uses_per_client
      t.integer :max_uses_per_promo
      t.string :promo_type
      t.decimal :amount_off
      t.references :couponable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
