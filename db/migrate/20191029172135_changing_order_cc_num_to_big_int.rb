class ChangingOrderCcNumToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :ccnum, :bigint
  end
end
