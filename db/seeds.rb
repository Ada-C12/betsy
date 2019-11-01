require 'csv'

USER_FILE = Rails.root.join('db', 'user-seeds.csv')
puts "Loading raw user data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.name = row['name']
  user.email = row['email']
  successful = user.save
  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "#{user_failures.length} users failed to save"



CATEGORY_FILE = Rails.root.join('db','categories-seeds.csv')
puts "Loading raw product data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']
  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save category #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "#{category_failures.length} products failed to save"

PRODUCT_FILE = Rails.root.join('db','products-seeds.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.qty = row['qty']
  product.price = row['price']
  product.description = row['description']
  product.status = row['status']
  product.photo_url = row['photo_url']
  product.user_id = User.find(rand(1..6)).id
  product.categories << Category.find(rand(1..4))
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "#{product_failures.length} products failed to save"

REVIEW_FILE = Rails.root.join('db','reviews-seeds.csv')
puts "Loading raw product data from #{REVIEW_FILE}"

review_failures = []
CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.rating = row['rating']
  review.review_text = row['text']
  review.product_id = Product.find(rand(1..Product.all.count)).id
  successful = review.save
  if !successful
    review_failures << review
    puts "Failed to save review #{review.inspect}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "#{review_failures.length} reviews failed to save"

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"