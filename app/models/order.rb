class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, through: :orderitems
  
  validates :status, presence: true, inclusion: { 
    in: %w(pending paid complete cancel),
    message: "%{value} is not a valid status" 
  }
  
  validates :orderitems, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :cc_name, presence: true, on: :update
  validates :cc_num, presence: true, numericality: { only_integer: true }, length: { minimum: 4 }, on: :update
  validates :cvv, presence: true, numericality: { only_integer: true }, on: :update
  validates :cc_exp, presence: true, on: :update
  validates :zip, presence: true, numericality: { only_integer: true }, on: :update
  
  def reduce_stock
    self.orderitems.each do |orderitem|
      orderitem.product.quantity -= orderitem.quantity
      orderitem.product.save
    end
  end
  
  def return_stock
    self.orderitems.each do |orderitem|
      orderitem.product.quantity += orderitem.quantity
      orderitem.product.save
    end
  end
  
  def total
    total_cost = 0
    
    self.orderitems.each do |orderitem|
      total_cost += orderitem.subtotal
    end
    
    return total_cost
  end
  
  # def mark_as_complete?
  #   if !self.orderitems.find_by(shipped: false)
  #     self.status = "complete"
  #     self.save
  #   end
  # end
end
