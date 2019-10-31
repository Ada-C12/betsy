class Review < ApplicationRecord
  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
  validates :title, presence: true
  validates_length_of :title, minimum: 1, maximum: 150
  validates :description, presence: true
  validates_length_of :description, minimum: 1, maximum: 350
  validates :product_id, presence: true
  
  belongs_to :product
  belongs_to :user, optional: true

  def self.rating_sentiment(rating)
    if rating > 5 || rating < 1
      return nil
    elsif rating < 3
      return "negative"
    elsif rating > 3
      return "positive"
    elsif rating == 3
      return "neutral"
    end
  end

end
