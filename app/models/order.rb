class Order < ApplicationRecord
  has_many :order_items
  
  validates :order_items, :length => { :minimum => 1 }, unless: Proc.new { |o| o.status == 'pending' }
  validates :email, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :name, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :owling_address, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :cc_num, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :cc_exp_mo, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :cc_exp_yr, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :cc_cvv, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :zip_code, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :status, presence: true
  
  def total
    return self.order_items.reduce(0) { |sum, item| sum + item.subtotal }
  end

  def self.cancel_abandoned_orders
    # pending_orders = Order.where(status: 'pending')
    # pending_orders.each do |order|
    #   p order
    #   order.update_attribute(:status, 'cancelled')
    #   p order
    #   order.save
    #   #  if (DateTime.now - order.created_at) <= 1
    # end
    # return pending_orders
  end
end
