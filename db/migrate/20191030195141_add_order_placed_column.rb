class AddOrderPlacedColumn < ActiveRecord::Migration[5.2]
  def change
    add_column(:orders, :order_place, :datetime)
  end
end
