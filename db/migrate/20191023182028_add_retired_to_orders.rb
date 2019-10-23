class AddRetiredToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :retired, :boolean, :default => false
  end
end
