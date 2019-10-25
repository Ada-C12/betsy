class Product < ApplicationRecord
  belongs_to :wizard
  has_many :reviews, dependent: :nullify
  has_many :order_items, dependent: :nullify
  has_and_belongs_to_many :categories, dependent: :nullify
end
