class Merchant < ApplicationRecord
  has_many :products
  
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  
  def self.build_from_github(auth_hash)
    # assembling Merchant.new() using info from github's auth_hash
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.name = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]
    
    # will Merchant.save() later inside ctrller
    return merchant
  end
  
end
