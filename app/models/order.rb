class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items
  
  validates :name, presence: true, if: :status_not_pending?
  validates :email, format: { with: /\w+@[a-zA-z]+\.[a-zA-z]{3}/, message: "Email invalid" }, if: :status_not_pending?
  validates :address, presence: true, if: :status_not_pending?
  validates :zip, presence: true, numericality: { only_integer: true }, length: { is: 5 }, if: :status_not_pending?
  validates :ccnum, presence: true, numericality: { only_integer: true }, length: { is: 16 }, if: :status_not_pending?
  validates :expdate, presence: true, format: { with: /^[0-1][0-9]\/\d{2}$/, :multiline => true, message: "MM/YY"}, if: :status_not_pending?
  validates :ccv, presence: true, numericality: { only_integer: true }, length: { is: 3 }, if: :status_not_pending?
  validates :status, presence: true
  
  
  def update_qty
    self.order_items.each do |item|
      item.product.qty -= item.qty
      item.product.save
    end
  end

  def total
    total = 0.0
    self.order_items.each do |oi|
      total += (oi.qty * oi.product.price)
    end
    return total
  end
  
  private
  
  def status_not_pending?
    status != "pending"
  end
end
