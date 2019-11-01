class ChangeRetireName < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :retire?, :retire
  end
end
