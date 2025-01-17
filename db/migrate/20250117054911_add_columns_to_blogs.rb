class AddColumnsToBlogs < ActiveRecord::Migration[7.0]
  def up
    remove_column :blogs, :card_image
    remove_column :blogs, :card_home_image
    remove_column :blogs, :banner_image
    add_column :blogs, :card_home_url_alt, :string
    add_column :blogs, :card_insights_url_alt, :string
    add_column :blogs, :banner_url_alt, :string
  end

  def down
    add_column :blogs, :card_image, :string
    add_column :blogs, :card_home_image, :string
    add_column :blogs, :banner_image, :string
    remove_column :blogs, :card_home_url_alt
    remove_column :blogs, :card_insights_url_alt
    remove_column :blogs, :banner_url_alt
  end
end
