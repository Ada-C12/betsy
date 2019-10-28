class AddPriceCentsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :price_cents, :integer
  end
end
