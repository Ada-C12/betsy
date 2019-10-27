class Category < ApplicationRecord
  has_and_belongs_to_many :products

  def self.products_by_category(category)
    category = Category.find_by(name: category)
    if category
      return category.products
    else
      return nil
    end
  end

end
