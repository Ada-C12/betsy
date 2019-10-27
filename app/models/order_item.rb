class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, :numericality => {only_integer: true, greater_than: 0}

  def subtotal
    return self.quantity * self.product.price
  end
end
