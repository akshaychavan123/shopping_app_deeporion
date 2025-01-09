class CreateBlogs < ActiveRecord::Migration[7.0]
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :category
      t.string :card_home_url
      t.string :card_insights_url
      t.string :banner_url
      t.string :card_home_image
      t.string :card_image
      t.string :banner_image
      t.text :body
      t.boolean :visibility
      t.date :publish_date
      t.bigint :publisher_id
      t.string :description
      t.string :path_name

      t.timestamps
    end

    add_index :blogs, :publisher_id
  end
end
