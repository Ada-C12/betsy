class RemoveMerchantidFromOrderitemColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_items, :merchants_id
  end
end
