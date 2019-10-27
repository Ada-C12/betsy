class Product < ApplicationRecord
  belongs_to :wizard
  has_many :reviews, dependent: :nullify
  has_many :order_items, dependent: :nullify
  has_and_belongs_to_many :categories, dependent: :nullify

  validates :name, presence: true
  validates_uniqueness_of :name
  validates :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }
  validates :stock, presence: true
  validates :stock, numericality: { only_integer: true }
  validates :wizard, presence: true
  validates_inclusion_of :retired, in: [true, false]

  def self.five_products
    return Product.all.sample(5)
  end

end
