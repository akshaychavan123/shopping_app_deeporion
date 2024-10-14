class CreateReturns < ActiveRecord::Migration[7.0]
  def change
    create_table :returns do |t|
      t.references :order, null: false, foreign_key: true
      t.references :order_item, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.text :reason
      t.decimal :refund_amount
      t.string :refund_method
      t.text :more_information

      t.timestamps
    end
  end
end
