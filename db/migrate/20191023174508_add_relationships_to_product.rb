class AddRelationshipsToProduct < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_items, :product, foreign_key: true
    add_reference :products, :user, foreign_key: true
  end
end
