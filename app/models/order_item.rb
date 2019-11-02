class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  
  validates :quantity, presence: true
  validates :quantity, :numericality => {:only_integer => true, greater_than: 0}
  
  def subtotal
    subtotal_cents = self.quantity * self.product.price_cents
    return Money.new(subtotal_cents)
  end
  
  def updated_stock
    return self.product.stock - self.quantity
  end
end
