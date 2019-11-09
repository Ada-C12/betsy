class AddDescriptionPhotoStatusToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :description, :string
    add_column :products, :photo_url, :string
    add_column :products, :status, :boolean
  end
end
