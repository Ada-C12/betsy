class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates_numericality_of :quantity, greater_than: 0
  # validates :quantity, numericality: {less_than_or_equal_to: :product_id.quantity, message: "desired quantity exceeds current quantity in stock"}
end
