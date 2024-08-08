class CreateCareerRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :career_roles do |t|
      t.text :role_name
      t.string :role_type
      t.string :location
      t.text :role_overview
      t.text :key_responsibility
      t.text :requirements
      t.string :email_id
      t.references :career, null: false, foreign_key: true

      t.timestamps
    end
  end
end
