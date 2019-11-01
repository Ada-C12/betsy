class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.string :email
      t.string :mailing_address 
      t.integer :zip 
      t.string :name_on_cc
      t.integer :cc_number 
      t.integer :cc_cvc
      t.string :cc_exp
      
      t.timestamps
    end
  end
end
