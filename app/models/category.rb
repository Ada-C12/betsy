class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: true

  def num_products_in_category
    return self.products.count
  end
end
