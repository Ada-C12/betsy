class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :stock
      t.string :name
      t.string :description
      t.string :photo_url
      t.integer :price

      
      t.timestamps
    end
  end
end
