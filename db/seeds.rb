# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"
WIZARD_FILE = Rails.root.join("db", "wizard_seeds.csv")
puts "Loading raw wizard data from #{WIZARD_FILE}"

wizard_failures = []
CSV.foreach(WIZARD_FILE, headers: true) do |row|
  wizard = Wizard.new
  wizard.id = row['id']
  wizard.username = row['username']
  wizard.email = row['email']
  successful = wizard.save
  if !successful
    wizard_failures << wizard
    puts "Failed to save wizard: #{wizard.inspect}"
  else
    puts "Created wizard: #{wizard.inspect}"
  end
end

puts "Added #{Wizard.count} wizard records"
puts "#{wizard_failures.length} wizards failed to save"


CATEGORY_FILE = Rails.root.join("db", "category_seeds.csv")
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, headers: true) do |row|
  category = Category.new
  category.id = row['id']
  category.name = row['name']
  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categorys failed to save"



PRODUCT_FILE = Rails.root.join("db", "product_seeds.csv")
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, headers: true) do |row|
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price_cents = row['price_cents']
  product.description = row['description']
  product.stock = row['stock']
  product.photo_url = row['photo_url']
  product.wizard_id = row['wizard_id']
  product.category_ids = row['category_ids']
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"



puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
