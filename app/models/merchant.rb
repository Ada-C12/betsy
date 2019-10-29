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

  def self.find_merchants_orderitems(current_merchant, status = nil)
    result = Orderitem.joins(product: :merchant).where(merchants: {id: current_merchant.id})
    if status == "true"
      return result.where(shipped: true)
    elsif status == "false"
      return result.where(shipped: false)
    else 
      return result
    end
  end

  def self.calculate_total_revenue(current_merchant)
    orderitems = Merchant.find_merchants_orderitems(current_merchant)
    
    if orderitems.length == 0 
      return 0
    else 
      prices = []
      orderitems.each do |orderitem|
        prices << orderitem.product.price * orderitem.quantity
      end
      return prices.sum
    end
  end

  def self.calc_rev_by_status(current_merchant, status)
    orderitems = Merchant.find_merchants_orderitems(current_merchant, status)
    
    if orderitems.length == 0 
      return 0
    else 
      prices = []
      orderitems.each do |orderitem|
        prices << orderitem.product.price * orderitem.quantity
      end
      return prices.sum
    end
  end 

end
