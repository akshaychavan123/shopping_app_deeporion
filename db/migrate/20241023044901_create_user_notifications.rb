class CreateUserNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :user_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.string :resource_type, null: false
      t.integer :resource_id, null: false
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
