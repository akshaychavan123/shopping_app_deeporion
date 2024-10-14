class CreateRefunds < ActiveRecord::Migration[7.0]
  def change
    create_table :refunds do |t|
      t.string :refund_id
      t.decimal :amount
      t.string :status
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
