class AddMailingAddressToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :street_address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :mailing_zip, :string
  end
end
