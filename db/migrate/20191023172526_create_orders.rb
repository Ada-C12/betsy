class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :email
      t.string :mailing_address
      t.string :name
      t.integer :cc_num
      t.integer :cc_exp_mo
      t.integer :cc_exp_yr
      t.integer :cc_cvv
      t.integer :zip_code
      t.string :status

      t.timestamps
    end
  end
end
