class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews
  has_and_belongs_to_many :categories
  belongs_to :user
  
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {only_float: true, greater_than: 0}
  validates :qty, presence: true, numericality: {only_integer: true} 
  
  def self.spotlight
    return Product.all.order('qty DESC' ).first
  end
  
  def self.newly_added
    products = Product.all.order('created_at DESC')
    if products
      return products[0..4]
    else
      return "No products found"
    end
  end
  
  def self.top_rated
    products = []
    
    Product.all.each do |product|
      if product.reviews.length > 0
        products << product
      end
    end
    products.sort_by {|product| - product.avg_rating }.first
  end
  
  def avg_rating
    reviews = Review.where(product_id: self.id)
    ratings = reviews.map do |review|
      review.rating
    end
    if ratings.count > 0
      return (ratings.sum / ratings.count)
    else
      "There aren't any ratings for this product yet."
    end
  end
end
