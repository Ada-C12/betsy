class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :email
      t.string :address
      t.string :name
      t.integer :ccnum
      t.string :expdate
      t.integer :ccv
      t.string :zip
      t.timestamps
    end
  end
end
