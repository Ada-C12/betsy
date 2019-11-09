require "csv"

# Merchant seeds

MERCHANT_FILE = Rails.root.join("db", "merchant-seeds.csv")
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new

  merchant.username = row["username"]
  merchant.email = row["email"]
  merchant.UID = row["uid"]
  merchant.provider = row["provider"]
  successful = merchant.save

  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

# Product seeds

PRODUCT_FILE = Rails.root.join("db", "product-seeds.csv")
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
# category = Category.where(name: "Accessories")
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new

  product.name = row["name"]
  product.price = row["price"]
  product.quantity = row["quantity"]
  product.merchant_id = row["merchant_id"]
  product.description = row["description"]
  product.photo_url = row["photo_url"]
  product.status = row["status"]
  # product.categories = category

  successful = product.save

  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
    puts "ERROR MESSAGES:*******#{product.errors.messages}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

# Category seeds

CATEGORY_FILE = Rails.root.join("db", "category-seeds.csv")
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new

  category.name = row["name"]

  successful = category.save

  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"

# Order seeds

ORDER_FILE = Rails.root.join("db", "order-seeds.csv")
puts "Loading raw order data from #{ORDER_FILE}"

order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new

  order.name = row["name"]
  order.address = row["address"]
  order.email = row["email"]
  order.credit_card_num = row["credit_card_num"]
  order.expiration_date = row["expiration_date"]
  order.cvv = row["cvv"]
  order.zip = row["zip"]
  order.status = row["status"]
  order.total_price = row["total_price"]
  order.placed_time = row["placed_time"]

  successful = order.save

  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    puts "Created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"

# Order-Item seeds

ORDER_ITEM_FILE = Rails.root.join("db", "order-item-seeds.csv")
puts "Loading raw order data from #{ORDER_ITEM_FILE}"

order_item_failures = []
CSV.foreach(ORDER_ITEM_FILE, :headers => true) do |row|
  order_item = OrderItem.new

  order_item.quantity = row["quantity"]
  order_item.product_id = row["product_id"]
  order_item.order_id = row["order_id"]
  order_item.shipping_status = row["shipping_status"]

  successful = order_item.save

  if !successful
    order_item_failures << order_item
    puts "Failed to save order item: #{order_item.inspect}"
    puts "ERROR MESSAGES:************* #{order_item.errors.messages}"
  else
    puts "Created order_item: #{order_item.inspect}"
  end
end

puts "Added #{OrderItem.count} order item records"
puts "#{order_item_failures.length} order items failed to save"

# # Review seeds

REVIEW_FILE = Rails.root.join("db", "review-seeds.csv")
puts "Loading raw review data from #{REVIEW_FILE}"

review_failures = []
CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new

  review.rating = row["rating"]
  review.text = row["text"]
  review.product_id = row["product_id"]

  successful = review.save

  if !successful
    review_failures << review
    puts "Failed to save review: #{review.inspect}"
    puts "*****ERROR MESSAGES: #{review.errors.messages}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"

# Categories Products seeds
# We will have to test whether the products are populating the categories through rails console just to double check..
CATEGORIES_PRODUCTS_FILE = Rails.root.join("db", "categories-products-seeds.csv")
puts "Loading raw categories-products data from #{CATEGORIES_PRODUCTS_FILE}"

CSV.foreach(CATEGORIES_PRODUCTS_FILE, :headers => true) do |row|
  category = Category.find_by(id: row["category_id"])
  puts "#{category} THIS IS THE CATEGORY!!!"
  product = Product.find_by(id: row["product_id"])
  puts "#{product} THIS IS THE PRODUCT!!!!"

  product.categories << category
end
