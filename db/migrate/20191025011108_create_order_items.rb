class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.string :shipping_status
      t.string :description
      t.string :photo_url
      t.integer :price
    end
  end
end



