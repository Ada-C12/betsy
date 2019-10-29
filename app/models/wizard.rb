class Wizard < ApplicationRecord
  has_many :products
  
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  


def total_revenue 
  total = 0 
  self.products.each do |product|
    product.order_items.each do |item|
      total += item.subtotal 
    end 
  end 

end 
  




end
