class RenameMailingAddressToOwlingAddressInOrders < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :mailing_address, :owling_address
  end
end
