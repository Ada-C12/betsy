class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  
  validates :status, presence: true
  
  validates :status, inclusion: { in: ["pending", "paid", "complete", "cancelled"] }
  
  validate :sufficient_order_items
  def sufficient_order_items
    id = self.id
    order_items = OrderItem.where(order_id: id)
    order = self
    if order.status == "paid" && order_items.count == 0
      errors.add(:order_items, "Insufficient order items in the cart to complete purchase")
    end
  end
  
  def self.formatter(integer)
    integer = integer.to_s
    integer.delete! "."
    
    cents = integer[-2..-1]
    dollars = integer[0..-3]
    return_statement = "#{dollars}.#{cents}"
  end
  
  
  def order_inspection
    order = Order.find_by(id: self.id)
    if order.status == "paid" && order.order_items.find_by(shipping_status: "pending").nil?
      order.status = "complete"
      order.save
    end
  end
  
  def self.price(id)
    order_items = OrderItem.where(order_id: id)
    
    total_order_price = 0
    
    order_items.each do |order_item|
      item_subtotal = order_item.quantity * Product.find(order_item.product_id).price
      
      total_order_price += item_subtotal
    end
    
    total_order_price *= 1.10
    
    formatted_total_order_price= formatter(total_order_price)
    
    return formatted_total_order_price
    
  end
  
  
  def revenue
    order_items.map(&:total).sum
  end
end



