class Merchant < ApplicationRecord
  has_many :products

  validates :uid, uniqueness: true, presence: true
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    return merchant
  end

  def calculate_total_revenue
    # if status isn't passed in, find all the merchants orderitems and 
    # return total revenue
    costs = []
    order_items = merchant_orderitems
    order_items.each do |orderitem|
      p orderitem.product.cost
    end

  end 

end
