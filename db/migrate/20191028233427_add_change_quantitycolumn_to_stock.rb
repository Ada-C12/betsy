class AddChangeQuantitycolumnToStock < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :quantity, :stock
  end
end
