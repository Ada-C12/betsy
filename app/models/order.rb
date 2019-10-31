class Order < ApplicationRecord
  has_many :order_items
  
  validates :order_items, :length => { :minimum => 1 }, unless: Proc.new { |o| o.status == 'pending' }
  validates :email, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  # Default email validation REGEX from https://api.rubyonrails.org/v5.1/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates 
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, unless: Proc.new { |o| o.status == 'pending' }
  validates :name, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :owling_address, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :name_on_cc, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :cc_num, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :cc_exp_mo, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :cc_exp_yr, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :cc_cvv, numericality: true, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :zip_code, numericality: true, length: { is: 5 }, presence: true, unless: Proc.new { |o| o.status == 'pending' }
  validates :status, presence: true
  
  def total
    total_cents = self.order_items.reduce(0) { |sum, item| sum + item.subtotal }
    return Money.new(total_cents)
  end
  
  def wizard_items_total(wizard)
    order_items = []
    self.order_items.each do |order_item|
      if wizard.products.include?(order_item.product)
        order_items << order_item.subtotal
      end
    end
    return order_items.sum
  end

  def complete_order
    self.status = "complete" if self.order_items.all? { |item| item.shipped == true }
    self.save
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
