class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, through: :orderitems
  
  validates :status, presence: true, inclusion: { 
    in: %w(pending paid complete cancel),
    message: "%{value} is not a valid status" 
  }
  
  validates :orderitems, length: { minimum: 1, message: "There are no items in your cart!" }, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :cc_name, presence: true, on: :update
  validates :cc_num, presence: true, numericality: { only_integer: true }, length: { minimum: 4 }, on: :update
  validates :cvv, presence: true, numericality: { only_integer: true }, on: :update
  validates :cc_exp, presence: true, on: :update
  validates :zip, presence: true, numericality: { only_integer: true }, on: :update
  
  def check_orderitems
    self.orderitems each do |orderitem|
      if !orderitem.valid?
        flash[:status] = :failure
        flash[:result_text] = "Sorry. Some of the items in your cart are no longer available."
        flash[:messages] << @orderitem.errors.messages
      end
    end
  end
  
  def reduce_stock
    self.orderitems.each do |orderitem|
      orderitem.product.quantity -= orderitem.quantity
      orderitem.product.save
    end
  end
  
  def return_stock
    self.orderitems.each do |orderitem|
      if !orderitem.product.retired
        orderitem.product.quantity += orderitem.quantity
        orderitem.product.save
      end
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
