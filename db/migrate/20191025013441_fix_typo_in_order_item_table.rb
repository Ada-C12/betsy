class FixTypoInOrderItemTable < ActiveRecord::Migration[5.2]
  def change
    remove_reference :order_items, :user
    add_reference :order_items, :order, foreign_key: true
  end
end
