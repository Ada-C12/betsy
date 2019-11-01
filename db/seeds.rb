# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# CATEGORY MODEL
CATEGORY_FILE = Rails.root.join('db', 'seed_data','categories.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []

CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.label = row['label']
  successful = category.save
  
  if !successful
    review_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save "

USERS_FILE = Rails.root.join('db', 'seed_data','users.csv')
puts "Loading raw usesrs data from #{USERS_FILE}"

user_failures = []

anonymous_user = User.new(id: 0, username: "Anonymous", email: nil, street_address: nil, city: nil, mailing_zip: nil, cc_name: nil, cc_number: nil, cc_expiration: nil, cvv: nil, billing_zip: nil)
anonymous_user.save

CSV.foreach(USERS_FILE, :headers => true) do |row|
  user = User.new
  user.username = row['username']
  user.email = row['email']
  user.street_address = row['street_address']
  user.city = row['city']
  user.mailing_zip = row['mailing_zip']
  user.cc_name = row['cc_name']
  user.cc_number = row['cc_number']
  user.cc_expiration = row['cc_expiration']
  user.cvv = row['cvv']
  user.billing_zip = row['billing_zip']
  successful = user.save
  
  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} user failed to save "

# PRODUCTS 
PRODUCTS_FILE = Rails.root.join('db', 'seed_data','products.csv')

puts "Loading raw products data from #{PRODUCTS_FILE}"

product_failures = []

CSV.foreach(PRODUCTS_FILE, headers: true) do |row|
  product = Product.new
  product.name = row['name']
  product.description = row['description']
  product.price = row['price']
  product.photo_url = row['photo_url']
  product.user_id = row['user_id']
  product.retired = row['retired']
  product.stock = row['stock']
  successful = product.save
  
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} product failed to save "


# REVIEW MODEL 
REVIEW_FILE = Rails.root.join("db", "seed_data/reviews.csv")
puts "Loading raw review data from #{REVIEW_FILE}"
review_failures = []

CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.id = row['id']
  review.product_id = row['product_id']
  review.user_review = row['user_review']
  review.rating = row['rating']
  review.user_id = row['user_id']
  
  successful = review.save
  
  if !successful
    review_failures << review
    puts "Failed to save review: #{review.inspect}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save "

# ORDERS 
ORDERS_FILE = Rails.root.join('db', 'seed_data','orders.csv')
puts "Loading raw orders data from #{ORDERS_FILE}"

order_failures = []

CSV.foreach(ORDERS_FILE, :headers => true) do |row|
  order = Order.new
  order.id = row['order_id']
  order_casi_dt = row['date_time_order_purchased']
  order.date_time_order_purchased = DateTime.parse(order_casi_dt)
  order.status = row['status']
  order.user_id = row['user_id'].to_i
  successful = order.save
  
  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    puts "Created order #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} order failed to save "
puts "#{order_failures}"



# # CATEGORIES_PRODUCTS
# CATEGORIES_PRODUCTS_FILE = Rails.root.join('db', 'seed_data','categories_products.csv')
# puts "Loading raw categories_products data from #{CATEGORIES_PRODUCTS_FILE}"

# categories_products_failures = []

# CSV.foreach(CATEGORIES_PRODUCTS_FILE, :headers => true) do |row|
#   category_product = Category_Product.new
#   category_product.category_id = row['category_id']
#   category_product.product_id = row['product_id']
#   successful = category_product.save

#   if !successful
#     category_product_failures << category_product
#     puts "Failed to save category_product: #{category_product.inspect}"
#   else
#     puts "Created category_product: #{category_product.inspect}"
#   end
# end

# puts "Added #{Category_Product.count} category_product records"
# puts "#{category_product_failures.length} category_product failed to save "


#Something is wrong with this model, which is why it's not recognizing this seed. :/


#CHECK ME!!
# # ORDER_ITEMS
ORDER_ITEMS_FILE = Rails.root.join('db', 'seed_data', 'order_items.csv')
puts "Loading raw order_items data from #{ORDER_ITEMS_FILE}"

order_item_failures = []

CSV.foreach(ORDER_ITEMS_FILE, :headers => true) do |row|
  order_item = OrderItem.new
  order_item.quantity = row['quantity'].to_i
  order_item.shipping_status = row['shipping_status']
  order_item.product_id = row['product_id']
  order_item.order_id = row['order_id']
  successful = order_item.save
  
  if !successful
    order_item_failures << order_item
    puts "Failed to save order_item: #{order_item.inspect}"
  else
    puts "Created order_item: #{order_item.inspect}"
  end
end

puts "Added #{OrderItem.count} order_item records"
puts "#{order_item_failures.length} order_item failed to save "


# adjusts the paid orders back
orders = Order.all
paid = [2, 6, 9]
orders.each do |order|
  if order.id == 2
    order.status = "paid"
    order.save
  elsif order.id == 6
    order.status = "paid"
    order.save
  elsif order.id == 9
    order.status = "paid"
    order.save
  end
end

