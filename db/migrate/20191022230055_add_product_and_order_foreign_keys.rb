class AddProductAndOrderForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_items, :product 
    add_reference :order_items, :order 
  end
end
