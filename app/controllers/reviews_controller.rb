class ReviewsController < ApplicationController

  def new
    @review = Review.new
  end
  
  def create
    @review = Review.new(rating: params[:review][:rating], product_id: params[:product_id], text: params[:review][:text])
    if session[:merchant_id] != nil && Product.find_by(id: params[:product_id]).merchant_id == session[:merchant_id]
      flash[:warning] = "You cannot review your own product"
      redirect_to product_path(params[:product_id])
      return
    elsif
      @review.save 
      flash[:success] = "Your review has been saved."
      redirect_to product_path(params[:product_id])
      return
    else 
      render :new
      return
    end
  end
  
  private 
  
  def review_params
    params.require(:review).permit(:rating, :text, :product_id)
  end
  
end
