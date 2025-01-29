require 'csv'

namespace :import do
  desc "Import categories from a CSV file"
  task categories: :environment do
    file_path = Rails.root.join("lib/assets/category_data.csv")

    unless File.exist?(file_path)
      puts "Error: File not found at #{file_path}"
      next
    end

    CSV.foreach(file_path, headers: false) do |row|
      category_id = row[0]
      category_chain = row[1..-1].compact_blank

      create_nested_categories(category_chain)
    end

    puts "Categories imported successfully!"
  end

  def create_nested_categories(category_names, parent = nil)
    category_names.each do |category_name|
      category = Category.find_or_create_by!(name: category_name, parent: parent)
      parent = category
    end
  end
end
