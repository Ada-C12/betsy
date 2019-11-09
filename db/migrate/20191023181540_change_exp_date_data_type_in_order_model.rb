class ChangeExpDateDataTypeInOrderModel < ActiveRecord::Migration[5.2]
  def change
    change_column(:orders, :expiration_date, :string)
  end
end
