class User < ApplicationRecord
  has_many :products
  has_many :reviews, dependent: :nullify

  validates :uid, uniqueness: true, presence: true 
  validates :merchant_name, uniqueness: true, :allow_nil => true
  validates_length_of :merchant_name, maximum: 50
  validates :username, uniqueness: true, presence: true 
  validates :email, uniqueness: true, presence: true, format: { with: /@/, message: "format must be valid." }

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]
    return user 
  end 

  def total_earned
    all_order_items = self.find_order_items
    total = 0 
    if all_order_items.length > 0 
      all_order_items.each do |orderitem|
        total += orderitem.total
      end 
    end 
    return total 
  end 

  #In this method we will find all the orders that belong to a user
  #We can pass those orders into the total_earned method
  def find_order_items
    all_products = self.find_products
    all_order_items = []

    all_products.each do |product|
      all_order_items << product.order_items
    end
    return all_order_items.flatten
  end 

  def find_products
    all_products = self.products 
    return all_products
  end 

end
