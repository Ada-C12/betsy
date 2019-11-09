class AddTextToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :text, :string
  end
end
