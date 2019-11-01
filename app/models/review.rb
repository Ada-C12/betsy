class Review < ApplicationRecord
  belongs_to :product
  validates :rating, presence: true, numericality: { only_integer: true, less_than: 6, greater_than: 0 }
  
  def self.sort_descending
    return Review.order(created_at: :desc)
  end
  
end
