class ReviewsController < ApplicationController
  skip_before_action :find_order
  
  def create
    @review = Review.new(review_params)

    if @review.valid?
      if @current_user && @review.product.user_id == @current_user.id
        flash[:error] = "You can't review your own product!"
        redirect_to product_path(@review.product.id)
        return
      elsif @current_user && !@current_user.reviews.where(product_id: @review.product_id).empty?
        flash[:error] = "You can't review a product more than once!"
        redirect_to product_path(@review.product.id)
        return
      elsif @review.save
        flash[:success] = "Your review has been added successfully!"
        redirect_to product_path(@review.product.id)
        return
      end
    else
      flash[:error] = "Something went wrong! Review was not added."
      redirect_to root_path
      return
    end
  end

  def destroy
    review = Review.find_by(id: params[:id])
    if review
      product = review.product
      if review.user_id && review.user_id == session[:user_id]
        review.destroy
        flash[:success] = "Your review was deleted!"
        redirect_to product_path(product.id)
        return
      else
        flash[:error] = "You cannot delete a review that isn't yours"
        redirect_to product_path(product.id)
        return
      end
    else
      flash[:error] = "The review doesn't exist anymore!"
      redirect_to root_path
      return
    end
  end
  
  private

  def review_params
    return params.require(:review).permit(:rating, :title, :description, :user_id, :product_id)
  end
end
