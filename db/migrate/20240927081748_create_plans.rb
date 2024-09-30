class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :service
      t.integer :amount
      t.string :frequency
      t.text :discription
      t.timestamps
    end
  end
end
