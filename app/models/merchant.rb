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

  def self.find_merchants_orderitems(current_merchant)
    Orderitem.joins(product: :merchant).where(merchants: {id: current_merchant.id})
  end

  def self.calculate_total_revenue(current_merchant)
    orderitems = Merchant.find_merchants_orderitems(current_merchant)
    prices = []
    orderitems.each do |orderitem|
      prices << orderitem.product.price * orderitem.quantity
    end
    return prices.sum

  end

  
  def revenue_for_shipped
    revenue = 0
    @merchant_orderitems.each do |orderitem|
      if orderitem.shipped 
        revenue += orderitem.product.price 
      end
    end

  end
end
