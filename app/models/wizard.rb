class Wizard < ApplicationRecord
  has_many :products

  def self.build_from_github(auth_hash)
    wizard = Wizard.new
    wizard.uid = auth_hash[:uid]
    wizard.provider = "github"
    wizard.username = auth_hash["info"]["nickname"]
    wizard.email = auth_hash["info"]["email"]
    
    return wizard
  end

end
