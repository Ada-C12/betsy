class ChangeReviewColumnName < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :review
    add_column :reviews, :review_text, :string
  end
end
