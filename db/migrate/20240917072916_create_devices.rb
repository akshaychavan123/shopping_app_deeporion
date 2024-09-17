class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :device_token
      t.string :device_type
      t.boolean :is_active, default: false

      t.timestamps
    end
  end
end
