class Wizard < ApplicationRecord
  has_many :products
  
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  def self.build_from_github(auth_hash)
    wizard = Wizard.new
    wizard.uid = auth_hash[:uid]
    wizard.provider = "github"
    wizard.username = auth_hash["info"]["nickname"]
    wizard.email = auth_hash["info"]["email"]
    
    return wizard
  end
  
end
