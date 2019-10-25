class RemoveRetiredFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :retired
  end
end
