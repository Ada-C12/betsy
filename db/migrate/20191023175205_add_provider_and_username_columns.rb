class AddProviderAndUsernameColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :username, :string 
  end
end
