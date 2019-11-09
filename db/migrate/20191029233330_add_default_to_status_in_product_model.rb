class AddDefaultToStatusInProductModel < ActiveRecord::Migration[5.2]
  def change
    change_column_default :products, :status, true
  end
end
