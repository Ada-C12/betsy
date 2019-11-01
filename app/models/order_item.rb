class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :qty, presence: true, numericality: {greater_than: 0}

  def increase_qty(num)
    self.qty += num
  end

end
