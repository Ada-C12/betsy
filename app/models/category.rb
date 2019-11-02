class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true
  validates :name, uniqueness: true

  FIXED_CATEGORIES_COUNT = 6

  def self.fixed_categories
    fixed_categories = Category.all.order(id: :asc).limit(FIXED_CATEGORIES_COUNT)
    return fixed_categories
  end


  def self.more_categories
    more_categories = Category.where.not(id: fixed_categories.ids)
    return more_categories
  end

  def self.all_alphabetized
    all_alphabetized = Category.all.order(name: :asc)
    return all_alphabetized
  end


  def self.select_options_names_ids
    category_names_and_ids = Category.all_alphabetized.map do |category|
      [category.name, category.id]
    end
    return category_names_and_ids
  end

end
