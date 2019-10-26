class ChangeTypeToCategorytype < ActiveRecord::Migration[5.2]
  def change
    rename_column :categories, :type, :category_type
  end
end
