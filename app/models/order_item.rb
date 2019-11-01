class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates_numericality_of :quantity, greater_than: 0
  
  def total
    (self.quantity * self.product.price)
  end

  def increase_quantity(quantity)
    existing_quantity = self.quantity
    new_quantity = existing_quantity + quantity

    return self.update(quantity: new_quantity)
  end
end
