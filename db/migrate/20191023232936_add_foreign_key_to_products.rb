class AddForeignKeyToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :merchant
  end
end
