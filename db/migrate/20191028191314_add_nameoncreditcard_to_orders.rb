class AddNameoncreditcardToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name_on_cc, :string
  end
end
