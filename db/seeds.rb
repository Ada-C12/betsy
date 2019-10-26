require 'csv'

USER_FILE = Rails.root.join('db', 'seed_data', 'users.csv')
puts "Loading raw user data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.uid = row['uid']
  user.merchant_name = row['merchant_name']
  user.email = row['email']
  user.provider = row['provider']
  user.username = row['username']
  successful = user.save
  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} users failed to save"

PRODUCTS_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
puts "Loading raw product data from #{PRODUCTS_FILE}"

product_failures = []
CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new
  product.img_url = row['img_url']
  product.name = row['name']
  product.description = "Here is a fun description about this fruit themed product!"
  product.price = rand(1..100)
  product.quantity = rand(1..100)
  
  user = User.find_by(uid: row['merchant'] )
  product.user_id = user.id
  
  if (row['fruit'])
    fruits = (row['fruit']).split(",")
    fruits.each do |fruit|
      cat = Category.find_by(name: fruit)
      if cat
        product.categories << cat
      else
        cat = Category.new(name: fruit, category_type: "fruit")
        if cat.save
          puts "Created category: #{cat.inspect}"
          product.categories << cat
        else
          puts "Failed to save category: #{cat.inspect}"
        end
      end    
    end
  end
  
  if (row['fruit_theme'])
    fruit_themes = (row['fruit_theme']).split(",")
    fruit_themes.each do |theme|
      cat = Category.find_by(name: theme)
      if cat
        product.categories << cat
      else
        cat = Category.new(name: theme, category_type: "theme")
        if cat.save
          puts "Created category: #{cat.inspect}"
          product.categories << cat
        else
          puts "Failed to save category: #{cat.inspect}"
        end
      end    
    end
  end
  
  if (row['category'])
    categories = (row['category']).split(",")
    categories.each do |category|
      cat = Category.find_by(name: category)
      if cat
        product.categories << cat
      else
        cat = Category.new(name: category, category_type: "category")
        if cat.save
          puts "Created category: #{cat.inspect}"
          product.categories << cat
        else
          puts "Failed to save category: #{cat.inspect}"
        end
      end    
    end
  end

  if (row['color']) 
    colors = (row['color']).split(",")
    colors.each do |color|
      cat = Category.find_by(name: color)
      if cat
        product.categories << cat
      else
        cat = Category.new(name: color, category_type: "color")
        if cat.save
          puts "Created category: #{cat.inspect}"
          product.categories << cat
        else
          puts "Failed to save category: #{cat.inspect}"
        end
      end    
    end
  end
  
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end


puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
