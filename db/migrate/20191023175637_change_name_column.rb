class ChangeNameColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :name, :merchant_name
  end
end
