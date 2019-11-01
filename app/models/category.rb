class Category < ApplicationRecord
  validates :name, presence: true
  has_and_belongs_to_many :products

  def self.products_by_category(category_name)
    category = Category.find_by(name: category_name)
    if category
      return category.products
    else
      return nil
    end
  end
end
