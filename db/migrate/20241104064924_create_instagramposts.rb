class CreateInstagramposts < ActiveRecord::Migration[7.0]
  def change
    create_table :instagramposts do |t|
      
      t.string :url
      t.string :description
      t.string :image
      t.timestamps
    end
  end
end
