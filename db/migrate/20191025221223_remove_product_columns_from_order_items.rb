class RemoveProductColumnsFromOrderItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_items, :description
    remove_column :order_items, :photo_url
    remove_column :order_items, :price
  end
end
