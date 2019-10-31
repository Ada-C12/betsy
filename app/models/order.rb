class Order < ApplicationRecord
  has_many :order_items
  
  validates :status, presence: true
  validates :name, presence: true, if: :not_pending?
  validates :email, presence: true, format: { with: /@/, message: "Email format must be valid." } , if: :not_pending?
  validates :address, presence: true, if: :not_pending?
  validates :cc_name, presence: true, if: :not_pending? 
  validates :cc_last4, presence: true, if: :not_pending?
  validates :cc_exp, presence: true, if: :not_pending?
  validates_numericality_of :cc_cvv, greater_than: 0, if: :not_pending?
  validates :billing_zip, presence: true, if: :not_pending?
  
  def not_pending?
    status != 'pending'
  end
  
  def contain_orderitems?(user)
    self.order_items.each do |order_item|
      return true if order_item.product.user_id == user.id
    end
    return false
  end

  def total
    total = 0 
    self.order_items.each do |orderitem|
      total += orderitem.total 
    end 
    return total 
  end

  def self.new_order
    order = Order.create(status: "pending")
    return order
  end
end
