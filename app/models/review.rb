class Review < ApplicationRecord
  validates :rating, presence: true
  validates :description, presence: true
  validates_length_of :description, minimum: 1, maximum: 350
  validates :user_id, presence: true, uniqueness: {scope: :product_id}
  validates :product_id, presence: true
  
  belongs_to :product
  belongs_to :user
end
