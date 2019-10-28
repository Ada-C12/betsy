class ChangeExpmoAndExpyrToStringInOrder < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc_exp_mo, :string
    change_column :orders, :cc_exp_yr, :string
  end
end
