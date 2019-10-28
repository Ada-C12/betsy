class Review < ApplicationRecord
  validates :rating, presence: true
  validates :description, presence: true
  validates_length_of :description, minimum: 1, maximum: 350
  validates :user_id, presence: true
  validates :product_id, presence: true
  
  belongs_to :product
  belongs_to :user
end
