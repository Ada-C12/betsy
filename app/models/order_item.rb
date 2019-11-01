class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validate :in_stock
  
  def total
    quantity * product.price
  end
  
  def in_stock
    if quantity > product.stock && order.status == "pending" 
      errors.add(:quantity, "can't be greater than what is currently in stock")
    end
  end
end

