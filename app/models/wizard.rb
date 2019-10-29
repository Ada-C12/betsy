class Wizard < ApplicationRecord
  has_many :products


def total_revenue 
  total = 0 
  self.products.each do |product|
    product.order_items.each do |item|
      total += item.subtotal 
    end 
  end 

end 


end
