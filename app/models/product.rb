class Product < ApplicationRecord
  belongs_to :wizard
  has_many :reviews, dependent: :nullify
  has_many :order_items, dependent: :nullify
  has_and_belongs_to_many :categories, dependent: :nullify
  
  validates :name, presence: true
  validates_uniqueness_of :name
  validates :price_cents, presence: true
  validates :price_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :stock, presence: true
  validates :stock, numericality: { only_integer: true, greater_than: 0 }
  validates :wizard, presence: true
  validates_inclusion_of :retired, in: [true, false]
  
  monetize :price_cents
  
  def self.five_products
    return Product.all.sample(5)
  end
  
  def self.list_unretired(wizard = nil)
    if wizard
      return wizard.products.reject { |product| product.retired == true }
    else
      return Product.all.reject { |product| product.retired == true }
    end
  end
  
  def make_retired_true
    self.retired = true
    self.save
  end
  
  def make_retired_false
    self.retired = false
    self.save
  end
end
