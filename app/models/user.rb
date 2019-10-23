class User < ApplicationRecord
  has_many :products

  validates :uid, uniqueness: true, presence: true 
  validates :merchant_name, uniqueness: true 
  validates :username, uniqueness: true, presence: true 
  validates :email, uniqueness: true, presence: true 

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]
    return user 
  end 
end
