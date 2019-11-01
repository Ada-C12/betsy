# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

MERCHANT_FILE = Rails.root.join('db', 'seed_data', 'merchants-seeds.csv')
CATEGORY_FILE = Rails.root.join('db', 'seed_data', 'categories-seeds.csv')
PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
ORDERPRODUCT_FILE = Rails.root.join('db', 'seed_data', 'orderproducts-seeds.csv')
ORDER_FILE = Rails.root.join('db', 'seed_data', 'orders-seeds.csv')
REVIEW_FILE = Rails.root.join('db', 'seed_data', 'reviews.csv')
CATEGORY_PRODUCTS_FILE = Rails.root.join('db', 'seed_data', 'categories-products-seeds.csv')

puts "Loading raw media data from #{MERCHANT_FILE}"
merchants_failures = []

CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.username = row['username']
  merchant.email = row['email']
  merchant.uid = row['uid']
  merchant.provider = row['provider']
  successful = merchant.save
  
  if !successful
    merchants_failures << merchant
    puts "Failed to save merchant: #{merchant.errors.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Loading raw media data from #{CATEGORY_FILE}"
categories_failures = []

CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']
  successful = category.save
  
  if !successful
    categories_failures << category
    puts "Failed to save category: #{category.errors.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Loading raw media data from #{PRODUCT_FILE}"
products_failures = []

CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.price = row['price']
  product.stock = row['stock']
  product.description = row['description']
  product.photo = row['photo']
  product.retire = row['retire']
  product.merchant_id = row['merchant_id']
  successful = product.save
  
  if !successful
    products_failures << product
    puts "Failed to save product: #{product.errors.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end 

puts "Loading raw media data from #{ORDER_FILE}"
orders_failures = []

CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.name = row['order']
  successful = order.save
  
  if !successful
    orders_failures << order
    puts "Failed to save order: #{order.errors.inspect}"
  else
    puts "Created order: #{order.inspect}"
  end
end

puts "Loading raw media data from #{REVIEW_FILE}"
review_failures = []

CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.product_id = row['product_id']
  review.rating = row['rating']
  review.text = row['text']
  successful = review.save
  
  if !successful
    review_failures << review
    puts "Failed to save review: #{review.errors.inspect}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "Loading raw media data from #{ORDERPRODUCT_FILE}"
orderproducts_failures = []

CSV.foreach(ORDERPRODUCT_FILE, :headers => true) do |row|
  orderproduct = Orderproduct.new
  orderproduct.quantity = row['quantity']
  orderproduct.order_id = row['order_id']
  orderproduct.product_id = row['product_id']
  successful = orderproduct.save
  
  if !successful
    orderproducts_failures << orderproduct
    puts "Failed to save orderproduct: #{orderproduct.errors.inspect}"
  else
    puts "Created orderproduct: #{orderproduct.inspect}"
  end
end

puts "Loading raw media data from #{CATEGORY_PRODUCTS_FILE}"
CSV.foreach(CATEGORY_PRODUCTS_FILE, :headers=>true ) do |row|
  category = Category.find_by(id: row["category_id"])
  puts "The category is #{category}!"
  product = Product.find_by(id: row["product_id"])
  puts "The product is #{product}!"
  product.categories << category
end 

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"