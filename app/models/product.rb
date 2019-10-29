class Product < ApplicationRecord
  has_many :reviews
  has_many :orderitems
  has_many :orders, through: :orderitems
  belongs_to :merchant
  has_and_belongs_to_many :types
  
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :retired, inclusion: { 
    in: [true, false],
    message: "retired status must be a boolean value: true or false" 
  }
end
