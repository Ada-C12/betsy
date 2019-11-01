class ReviewsController < ApplicationController
  skip_before_action :find_order
  skip_before_action :require_login, :only => [:create]
  
  def create
    @review = Review.new(review_params)

    if @review.valid?
      if current_user && @review.product.user_id == current_user.id
        flash[:error] = "You can't review your own product!"
      elsif current_user && !current_user.reviews.where(product_id: @review.product_id).empty?
        flash[:error] = "You can't review a product more than once!"
      elsif @review.save
        flash[:success] = "Your #{Review.rating_sentiment(@review.rating)} review on #{@review.product.name} was added successfully!"
      else
        flash[:error] = "Something went wrong! Your review was not saved!"
      end
    else
      flash[:error] = "Review was not added. Please check required fields before submitting."
      flash[:errors] = @review.errors.messages
    end

    return redirect_to product_path(@review.product.id)
  end

  def destroy
    review = Review.find_by(id: params[:id])
    if review
      product = review.product
      if review.user_id && review.user_id == session[:user_id]
        review.destroy
        flash[:success] = "Your review was deleted!"
      else
        flash[:error] = "You cannot delete a review that isn't yours"
      end
      return redirect_to product_path(product.id)
    else
      flash[:error] = "The review doesn't exist anymore!"
      return redirect_to root_path
    end
  end
  
  private

  def review_params
    return params.require(:review).permit(:rating, :title, :description, :user_id, :product_id)
  end
end
