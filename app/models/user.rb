class User < ApplicationRecord
  has_many :products
  
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  
  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.name = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]
    return user
  end
  
  def total_revenue(status = nil)
    if status == nil
      order_items = OrderItem.where(product_id: Product.where(user_id: self.id)).where(order_id: Order.where.not(status: ['pending', 'cancelled']))
    else
      order_items = OrderItem.where(product_id: Product.where(user_id: self.id)).where(order_id: Order.where(status: status))
    end
    order_items = order_items.map do |item|
      item.product.price * item.qty
    end
    return '%.2f' % order_items.sum.to_f
  end
  
  def order_list(status = nil)
    if status == nil
      order_items = OrderItem.where(product_id: Product.where(user_id: self.id))
    else
      order_items = OrderItem.where(product_id: Product.where(user_id: self.id)).where(order_id: Order.where(status: status))
    end
    orders = []
    order_items.each do |item|
      if orders.include?(item.order_id)
      else
        orders << item.order_id
      end
    end
    return orders
  end
end
