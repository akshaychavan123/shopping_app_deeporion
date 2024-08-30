class ModifyVideoLibrary < ActiveRecord::Migration[7.0]
  def change
    remove_column :video_libraries, :description, :text

    add_reference :video_libraries, :video_description, null: false, foreign_key: true
  end
end
