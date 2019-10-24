class ChangeCcnumToStringInOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc_num, :string
  end
end
