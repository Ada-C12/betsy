class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true
  validates :name, uniqueness: true

  FIXED_CATEGORIES_IDS = (1..6)

  def self.fixed_categories
    fixed_categories = Category.where(id: FIXED_CATEGORIES_IDS)
    return fixed_categories
  end


  def self.more_categories
    more_categories = Category.where.not(id: FIXED_CATEGORIES_IDS)
    return more_categories
  end


  def self.select_options_names_ids
    category_names_and_ids = Category.all.map do |category|
      [category.name, category.id]
    end
    return category_names_and_ids
  end

end
