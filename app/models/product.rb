class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates_length_of :name, minimum: 1, maximum: 50
  validates :price, presence: true
  validates :quantity, presence: true
  validates :user_id, presence: true
  validates :img_url, presence: true
  validates :description, presence: true
  
  belongs_to :user
  has_many :order_items
  has_and_belongs_to_many :categories

  def quantity_available?(quantity)
    if quantity.nil? || quantity < 1
      return nil
    elsif quantity > self.quantity
      return false
    else
      return true
    end
  end

  def update_quantity
  end

  def avg_rating
  end
end
