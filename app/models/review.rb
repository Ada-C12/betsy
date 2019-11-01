class Review < ApplicationRecord
  belongs_to :product
  validates :rating, presence: true, numericality: true, inclusion: {:in => 1..5, :message => "Value should be between 1 and 5"}
end
