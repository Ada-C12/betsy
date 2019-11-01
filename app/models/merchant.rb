class Merchant < ApplicationRecord
  has_many :products
  
  validates :username, presence: true
  
  validates :email, presence: true
  validates :email, uniqueness: true
  
  validates :uid, presence: true
  validates :uid, uniqueness: true
  
  validates :provider, presence: true
  
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    
    return merchant
  end
  
  def fulfillments
    ordered_products = []
    self.products.each do |product|
      product.orderproducts.each do |orderproduct|
        ordered_products << orderproduct
      end
    end
    return ordered_products
  end
end
