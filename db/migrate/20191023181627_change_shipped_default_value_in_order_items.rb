class ChangeShippedDefaultValueInOrderItems < ActiveRecord::Migration[5.2]
  def change
    change_column :order_items, :shipped, :boolean, :default => false
  end
end
