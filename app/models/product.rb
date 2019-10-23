class Product < ApplicationRecord
  belongs_to :wizard
  has_many :reviews
  has_many :order_items
end
