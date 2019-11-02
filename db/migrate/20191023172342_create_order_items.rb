class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.boolean :shipped
      t.integer :quantity

      t.timestamps
    end
  end
end
