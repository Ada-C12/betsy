class ChangeActiveToDefaultTrue < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :active
    add_column :products, :active, :boolean, default: true 
  end
end
