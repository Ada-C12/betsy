class ChangeCategoryToNameAddType < ActiveRecord::Migration[5.2]
  def change
    rename_column :categories, :category, :name
    add_column :categories, :type, :string
  end
end
