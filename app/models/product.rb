class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :user_id}
  validates_length_of :name, minimum: 1, maximum: 50
  validates :category, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :user_id, presence: true
  
  belongs_to :user
  has_many :order_items
end
