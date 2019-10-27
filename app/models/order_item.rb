class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  
  validates :quantity, presence: true
  validates :quantity, :numericality => {:only_integer => true, greater_than: 0}
end
