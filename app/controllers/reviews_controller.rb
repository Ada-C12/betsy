class ReviewsController < ApplicationController
  skip_before_action :require_login, :only => [:create, :show]
  skip_before_action :find_order
  
  def create
    @review = Review.new(review_params)

    if @review.save
      flash[:success] = "Your review has been added successfully"
      product = @review.product
      redirect_to product_path(product.id)
      return
    else
      flash.now[:error] = "Something went wrong! Review was not added."
      redirect_to root_path
      return
    end
  end

  def destroy
    review = Review.find_by(id: params[:id])
    if review
      product = review.product
      if review.user_id == session[:user_id]
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
    return params.require(:review).permit(:rating, :description, :user_id, :product_id)
  end
end
