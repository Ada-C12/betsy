class ReviewsController < ApplicationController
  
  def new
    @review = Review.new
  end
  
  def create
    @product = Product.find_by(id: params[:product_id])
    
    if @product.nil?
      head :not_found
      return
    end
    
    if @product.merchant.id == session[:merchant_id]
      flash[:status] = :failure
      flash[:result_text] = "Users cannot review their own products!"
      redirect_to product_path(params[:product_id])
      return
    end
    
    @review = Review.new(review_params)
    @review.product_id = @product.id
    
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Thank you! Your review has been saved."
      redirect_to product_path(params[:product_id])
      return
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not save your review. Please check below and submit again."
      flash.now[:messages] = @review.errors.messages
      render :new, status: :bad_request
      return
    end
  end
  
  private
  
  def review_params
    params.require(:review).permit(:rating, :text_review)
  end
end

