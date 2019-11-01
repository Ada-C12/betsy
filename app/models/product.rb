class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_many :orderproducts
  has_and_belongs_to_many :categories
  has_many :orders, through: :orderproducts, dependent: :destroy
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than: -1 }
  
  # TODO: test me
  def average_rating
    if self.reviews.count > 0
      (self.reviews.map{ |review| review.rating }.sum / self.reviews.count.to_f).round(1)
    end
  end

  def self.sort_ascending
    return Product.order(name: :asc)
  end

end
