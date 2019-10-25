class Product < ApplicationRecord
  belongs_to :wizard
<<<<<<< HEAD
  has_many :reviews, dependent: :nullify
  has_many :order_items, dependent: :nullify
  has_and_belongs_to_many :categories, dependent: :nullify

  validates_inclusion_of :retired, in: [true, false]

  def self.five_products
    return Product.all.sample(5)
  end
  
end
