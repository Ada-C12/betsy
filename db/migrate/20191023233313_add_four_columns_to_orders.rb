class AddFourColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :status, :string
    add_column :orders, :total_price, :float
    add_column :orders, :placed_time, :datetime

    remove_column :orders, :expiration_date
    add_column :orders, :expiration_date, :string
  end
end
