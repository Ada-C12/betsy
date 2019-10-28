class AddShippedToOrderitems < ActiveRecord::Migration[5.2]
  def change
    add_column :orderitems, :shipped, :boolean
  end
end
