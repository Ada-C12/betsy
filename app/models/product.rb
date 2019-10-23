class Product < ApplicationRecord
  belongs_to :wizard
  has_many :reviews
end
