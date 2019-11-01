class AddColumnsToOrderproduct < ActiveRecord::Migration[5.2]
  def change
    add_reference :orderproducts, :product, foreign_key: true
    add_reference :orderproducts, :order, foreign_key: true
  end
end
