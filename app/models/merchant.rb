class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    
    merchant = Merchant.new
    merchant.UID = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash[:info][:nickname]
    merchant.email = auth_hash[:info][:email]
    return merchant
  end
end
