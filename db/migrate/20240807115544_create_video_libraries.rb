class CreateVideoLibraries < ActiveRecord::Migration[7.0]
  def change
    create_table :video_libraries do |t|
      t.text :description
      t.string :video_link

      t.timestamps
    end
  end
end
