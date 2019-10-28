require 'csv'

# seed merchants
MERCHANT_FILE = Rails.root.join('db', 'seed_data', 'merchants.csv')
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.username = row['username']
  merchant.email= row['email']
  merchant.uid = row['uid']
  merchant.provider= row['provider']

  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
    puts "#{merchant.errors.messages}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

# seed products
PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.description = row['description']
  product.price = row['price']
  product.photo_url = row['photo_url']
  product.stock = row['stock']
  product.merchant_id = row['merchant_id']
  product.retired = row['retired']

  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
    puts "#{product.errors.messages}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

# seed types
TYPE_FILE = Rails.root.join('db', 'seed_data', 'types.csv')
puts "Loading raw product data from #{TYPE_FILE}"

type_failures = []
CSV.foreach(TYPE_FILE, :headers => true) do |row|
  type = Type.new
  type.name = row['name']

  successful = type.save
  if !successful
    type_failures << product
    puts "Failed to save type: #{type.inspect}"
    puts "#{type.errors.messages}"
  else
    puts "Created type: #{type.inspect}"
  end
end

puts "Added #{Type.count} type records"
puts "#{type_failures.length} types failed to save"

# seed orders
ORDER_FILE = Rails.root.join('db', 'seed_data', 'orders.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.email = row['email']
  order.address = row['address']
  order.cc_name = row['cc_name']
  order.cc_num = row['cc_num']
  order.cvv = row['cvv']
  order.cc_exp = row['cc_exp']
  order.zip = row['zip']
  order.status = row['status']

  successful = order.save
  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
    puts "#{order.errors.messages}"
  else
    puts "Created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} product records"
puts "#{order_failures.length} products failed to save"

# seed orderitems
ORDERITEM_FILE = Rails.root.join('db', 'seed_data', 'orderitems.csv')
puts "Loading raw product data from #{ORDERITEM_FILE}"

orderitem_failures = []
CSV.foreach(ORDERITEM_FILE, :headers => true) do |row|
  orderitem = Orderitem.new
  orderitem.quantity = row['quantity']
  orderitem.product_id = row['product_id']
  orderitem.order_id = row['order_id']
  orderitem.shipped = row['shipped']
  

  successful = orderitem.save
  if !successful
    orderitem_failures << orderitem
    puts "Failed to save orderitem: #{orderitem.inspect}"
    puts "#{orderitem.errors.messages}"
  else
    puts "Created orderitem: #{orderitem.inspect}"
  end
end

puts "Added #{Order.count} product records"
puts "#{order_failures.length} products failed to save"