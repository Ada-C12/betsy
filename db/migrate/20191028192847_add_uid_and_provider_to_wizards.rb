class AddUidAndProviderToWizards < ActiveRecord::Migration[5.2]
  def change
    add_column :wizards, :uid, :integer
    add_column :wizards, :provider, :string
  end
end
