# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb
# admin = User.find_or_create_by(email: "admin@yopmail.com") do |u|
#     u.name = "admin"
#     u.password = "Test@123"
#     u.type = "Admin"
#     u.terms_and_condition = true
#   end

#   categories = {
#     'Woman' => {
#       'Indian & Fusion Wears' => ['Kurtas & Suits', 'Kurtis, Tunics & Tops', 'Sarees', 'Leggings & Salwars', 'Skirts & Palazzos', 'Dress Materials', 'Lehenga Cholis', 'Dupattas & Shawls', 'Jackets'],
#       'Western Wears' => ['Dresses', 'Tops & Tshirts', 'Jeans', 'Trousers & Capris', 'Shorts & Skirts', 'Co-ords', 'Playsuits & Jumpsuits', 'Jackets & Coats', 'Sweaters & Sweatshirts'],
#       'Footwears' => ['Flats', 'Casual Shoes', 'Heels', 'Boots', 'Sports Shoes & Floaters'],
#       'Sleepwear & Loungewear' => ['Night suits', 'Swimwear', 'Thermals']
#     },
#     'Men' => {
#       'Indian & Fusion Wears' => ['Kurtas & Suits', 'Indian Wear', 'Resort Wear'],
#       'Western Wears' => ['Shirts', 'T-Shirts', 'Jeans', 'Pants & Shorts'],
#       'Footwears' => ['Flats', 'Casual Shoes', 'Sports Shoes'],
#       'Sleepwear & Loungewear' => ['Night suits', 'Swimwear', 'Thermals']
#     },
#     'Kids' => {
#       'Girls' => ['All Girls', 'Dresses', 'Indian Wear', 'Pajama Sets', 'Resort wear', 'Pyjama sets'],
#       'Boys' => ['All Boys', 'Shirts', 'Kurtas', 'Pants & Shorts', 'Indian Wear', 'Resort Wear'],
#       'Baby' => ['All Baby', 'Daily Wear', 'Vacation Wear', 'Indian Wear', 'Winter Wear']
#     }
#   }
  
#   categories.each do |category_name, subcategories|
#     category = Category.find_or_create_by(name: category_name)
  
#     subcategories.each do |subcategory_name, products|
#       subcategory = Subcategory.find_or_create_by(name: subcategory_name, category: category)
  
#       products.each do |product_name|
#         product = Product.find_or_create_by(name: product_name, subcategory: subcategory)
#       end
#     end
#   end

# db/seeds.rb

# Add admin user, categories, subcategories, and products as before
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

      5.times do
        unique_product_code = Faker::Code.asin
        while ProductItem.exists?(product_code: unique_product_code)
          unique_product_code = Faker::Code.asin
        end
        product_item = ProductItem.create!(
          product: product,
          name: "#{product_name} Item #{rand(1..100)}",
          brand: Faker::Company.name,
          description: Faker::Lorem.sentence,
          size: ["XS", "S", "M", "L", "XL"].sample,
          material: Faker::Commerce.material,
          care: "Machine wash",
          product_code: unique_product_code,
          care_instructions: Faker::Lorem.paragraph,
          fabric: ["Cotton", "Polyester", "Wool"].sample,
          hemline: ["Straight", "Curved", "Round"].sample,
          neck: ["Round Neck", "V-Neck", "Collared"].sample,
          texttile_thread: Faker::Lorem.word,
          size_and_fit: "Regular Fit",
          main_trend: Faker::Commerce.department,
          knite_or_woven: ["Knitted", "Woven"].sample,
          length: ["Full Length", "3/4 Length", "Short"].sample,
          occasion: ["Casual", "Formal", "Party"].sample,
          color: Faker::Color.color_name,
          height: "#{rand(140..200)} cm"
        )

        product_item.image.attach(
          io: File.open("/home/manoj/Downloads/User (Webp images)/Product detail page/Product detail view 1.webp"),
          filename: "Product_detail_view_1.webp",
          content_type: "image/webp"
        )
        product_item.photos.attach([
          {
            io: File.open("/home/manoj/Downloads/Product detail_/Frame 6356836.webp"),
            filename: "Frame_6356836.webp",
            content_type: "image/webp"
          },
          {
            io: File.open("/home/manoj/Downloads/Product detail_/Frame 6356835.webp"),
            filename: "Frame_6356835.webp",
            content_type: "image/webp"
          }
        ])        

        sizes = ["XS", "S", "M", "L", "XL"]

        5.times do
          variant_price = Faker::Commerce.price(range: 10..100)

          unique_size = sizes.pop 

          ProductItemVariant.create!(
            product_item: product_item,
            size: unique_size,
            price: variant_price,
            quantity: rand(1..50),
            in_stock: true,
            discounted_price: variant_price,
            discount_percent: 0
          )
        end   
      end
    end
  end
end

puts "Seeding completed with images and photos!"
