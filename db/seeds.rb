# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb
admin = User.find_or_create_by(email: "admin@yopmail.com") do |u|
    u.name = "admin"
    u.password = "Test@123"
    u.type = "Admin"
    u.terms_and_condition = true
  end

  categories = {
    'Woman' => {
      'Indian & Fusion Wears' => ['Kurtas & Suits', 'Kurtis, Tunics & Tops', 'Sarees', 'Leggings & Salwars', 'Skirts & Palazzos', 'Dress Materials', 'Lehenga Cholis', 'Dupattas & Shawls', 'Jackets'],
      'Western Wears' => ['Dresses', 'Tops & Tshirts', 'Jeans', 'Trousers & Capris', 'Shorts & Skirts', 'Co-ords', 'Playsuits & Jumpsuits', 'Jackets & Coats', 'Sweaters & Sweatshirts'],
      'Footwears' => ['Flats', 'Casual Shoes', 'Heels', 'Boots', 'Sports Shoes & Floaters'],
      'Sleepwear & Loungewear' => ['Night suits', 'Swimwear', 'Thermals']
    },
    'Men' => {
      'Indian & Fusion Wears' => ['Kurtas & Suits', 'Indian Wear', 'Resort Wear'],
      'Western Wears' => ['Shirts', 'T-Shirts', 'Jeans', 'Pants & Shorts'],
      'Footwears' => ['Flats', 'Casual Shoes', 'Sports Shoes'],
      'Sleepwear & Loungewear' => ['Night suits', 'Swimwear', 'Thermals']
    },
    'Kids' => {
      'Girls' => ['All Girls', 'Dresses', 'Indian Wear', 'Pajama Sets', 'Resort wear', 'Pyjama sets'],
      'Boys' => ['All Boys', 'Shirts', 'Kurtas', 'Pants & Shorts', 'Indian Wear', 'Resort Wear'],
      'Baby' => ['All Baby', 'Daily Wear', 'Vacation Wear', 'Indian Wear', 'Winter Wear']
    }
  }
  
  categories.each do |category_name, subcategories|
    category = Category.find_or_create_by(name: category_name)
  
    subcategories.each do |subcategory_name, products|
      subcategory = Subcategory.find_or_create_by(name: subcategory_name, category: category)
  
      products.each do |product_name|
        product = Product.find_or_create_by(name: product_name, subcategory: subcategory)
      end
    end
  end