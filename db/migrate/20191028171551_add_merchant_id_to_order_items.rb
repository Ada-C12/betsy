class AddMerchantIdToOrderItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_items, :merchants, foreign_key: :true
    change_column_default :products, :photo_url, "https://i.imgur.com/CSul8N3.jpg"
  end
end
