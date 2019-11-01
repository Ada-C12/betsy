class AddDateTimeOrderPurchasedToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :date_time_order_purchased, :datetime
  end
end
