class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates_numericality_of :quantity, greater_than: 0
  
  def total
    (self.quantity * self.product.price)
  end
  
end
