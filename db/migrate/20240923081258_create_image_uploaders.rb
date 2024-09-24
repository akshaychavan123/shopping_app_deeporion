class CreateImageUploaders < ActiveRecord::Migration[7.0]
  def change
    create_table :image_uploaders do |t|
      t.string :name

      t.timestamps
    end
  end
end
