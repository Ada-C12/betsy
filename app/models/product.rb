class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates_length_of :name, minimum: 1, maximum: 50
  validates :price, presence: true
  validates :quantity, presence: true
  validates :user_id, presence: true
  validates :img_url, presence: true
  validates :description, presence: true
  
  belongs_to :user
  has_many :order_items, dependent: :nullify
  has_and_belongs_to_many :categories

    
  def self.random_products(num)
    return Product.all.shuffle.first(num)
  end
  
  def self.deals_under(price)  
    return Product.where("price < ?", price).shuffle
  end

  def quantity_available?(quantity)
    if quantity.nil? || quantity < 1
      return nil
    elsif quantity > self.quantity
      return false
    else
      return true
    end
  end

  def find_order_items
    all_products = @current_user.find_products
    all_order_items = []
    all_products.each do |product| 
      all_order_items << OrderItem.find_by(product_id: product.id)
    end 
    all_order_items = self.where(product_id: self)
  end 


  def quantity_available?(input_quantity)
    if input_quantity > self.quantity
      return false
    else
      return true
    end
  end

  def avg_rating
  end

end
