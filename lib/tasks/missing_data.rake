namespace :data do
  desc "Seed data for categories, and banners in an e-commerce app"
  task create: :environment do
    categories = [
      { name: "Electronics" },
      { name: "Fashion" },
      { name: "Home Appliances" },
      { name: "Books" },
      { name: "Beauty Products" }
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

    # Create banners
    banners.each do |banner_data|
      Banner.find_or_create_by(banner_data)
    end
    puts "Banners created successfully!"
  end
end
