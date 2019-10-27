class AddReviewCommentToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :review_comment, :string 
  end
end
