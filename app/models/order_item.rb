class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates_numericality_of :quantity, greater_than: 0
  
  # validates :quantity, numericality: {less_than_or_equal_to: :product_id.quantity, message: "desired quantity exceeds current quantity in stock"}

  #Make a method to validate the current quantity of the product that is being ordered is the same as the amount that exists 
  #Make a class method to find out the total amount of profit 
  
  def total
    (self.quantity * self.product.price)
  end

  def increase_quantity(quantity)
    existing_quantity = self.quantity
    new_quantity = existing_quantity + quantity

    return self.update(quantity: new_quantity)
  end
  
end
