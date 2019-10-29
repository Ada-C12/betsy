class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end
  
  def create
    @review = Review.new(review_params)
    @review.product_id = params[:product_id]
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Thank you! Your review has been saved."
      redirect_to product_path(params[:product_id])
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not save your review. Please check below and submit again."
      flash.now[:messages] = @review.errors.messages
      render :new, status: :bad_request
    end
  end
  
  private
  
  def review_params
    params.require(:review).permit(:rating, :text_review)
  end
end

