namespace :data do
  desc "Seed data for categories, subcategories, and banners in an e-commerce app"
  task create: :environment do
    categories = [
      { name: "Electronics" },
      { name: "Fashion" },
      { name: "Home Appliances" },
      { name: "Books" },
      { name: "Beauty Products" }
    ]

    subcategories = [
      { name: "Mobile Phones", category_name: "Electronics" },
      { name: "Laptops", category_name: "Electronics" },
      { name: "Men's Clothing", category_name: "Fashion" },
      { name: "Women's Clothing", category_name: "Fashion" },
      { name: "Kitchen Appliances", category_name: "Home Appliances" },
      { name: "Fiction", category_name: "Books" },
      { name: "Non-fiction", category_name: "Books" },
      { name: "Makeup", category_name: "Beauty Products" },
      { name: "Skincare", category_name: "Beauty Products" }
    ]

    banners = [
      { heading: "Big Sale on Electronics!", description: "Up to 50% off on mobile phones and laptops", banner_type: "advertisement" },
      { heading: "Fashion Fiesta", description: "Trendy outfits at unbeatable prices", banner_type: "advertisement" },
      { heading: "Upgrade Your Home", description: "Exclusive deals on kitchen appliances", banner_type: "advertisement" },
      { heading: "Bookworms' Paradise", description: "Discover your next great read", banner_type: "advertisement" },
      { heading: "Glow Up!", description: "Best beauty products for your skincare routine", banner_type: "advertisement" }
    ]

    # Create categories
    categories.each do |category_data|
      Category.find_or_create_by(name: category_data[:name])
    end
    puts "Categories created successfully!"

    # Create subcategories
    subcategories.each do |subcategory_data|
      category = Category.find_by(name: subcategory_data[:category_name])
      if category
        Subcategory.find_or_create_by(name: subcategory_data[:name], category_id: category.id)
      else
        puts "Category '#{subcategory_data[:category_name]}' not found for Subcategory '#{subcategory_data[:name]}'"
      end
    end
    puts "Subcategories created successfully!"

    # Create banners
    banners.each do |banner_data|
      Banner.find_or_create_by(banner_data)
    end
    puts "Banners created successfully!"
  end
end
