class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners do |t|
      t.string :heading
      t.text :description
      t.string :banner_type

      t.timestamps
    end
  end
end
