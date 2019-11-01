class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|

      t.string :username
      t.string :email
      t.string :address
      t.string :cc_name
      t.string :cc_number
      t.string :cc_expiration
      t.string :cvv
      t.string :billing_zip
     

      t.timestamps
    end
  end
end
