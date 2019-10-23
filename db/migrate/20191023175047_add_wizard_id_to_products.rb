class AddWizardIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :wizard, foreign_key: true
  end
end
