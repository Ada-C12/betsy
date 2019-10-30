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
    all_order_items.each do |item|
    status = item.order.status
      if status == "paid" || status == "completed"
        total += item.total
      end 
    end 
    return total 
  end 

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

  def filter_order_items(status)
    order_items = []
    self.find_products.each do |product|
      product.order_items.each do |order_item|
        order_items << order_item if order_item.order.status == status
      end
    end
    return order_items
  end
end
