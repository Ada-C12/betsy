class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  has_one :merchant, through: :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
