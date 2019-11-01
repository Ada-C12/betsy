class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :stock
      t.string :description
      t.string :photo
      t.boolean :retire?

      t.timestamps
    end
  end
end
