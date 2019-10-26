class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates_numericality_of :quantity, greater_than: 0


  #For each order item it calls 
end
