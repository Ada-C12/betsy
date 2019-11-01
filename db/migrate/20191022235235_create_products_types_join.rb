class CreateProductsTypesJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :products_types do |t|
      t.belongs_to :product, index: true
      t.belongs_to :type, index: true
    end
  end
end
