class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.boolean :app, default: true
      t.boolean :email, default: false
      t.boolean :sms, default: false
      t.boolean :whatsapp, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
