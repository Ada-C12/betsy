class CreateOrderproducts < ActiveRecord::Migration[5.2]
  def change
    create_table :orderproducts do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
