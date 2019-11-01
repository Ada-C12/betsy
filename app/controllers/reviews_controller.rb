class ReviewsController < ApplicationController
  
  skip_before_action :require_login
  
  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end
  
  def create
    @product = Product.find_by(id: params[:product_id])
    # binding.pry
    @review = Review.new(review_params)
    @review.product_id = @product.id
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created review"
      redirect_to product_path(@product)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create review"
      flash[:messages] = @review.errors.messages
      render :new, status: :bad_request
    end
  end
  
  private
  
  def review_params
    return params.permit(:rating, :review_text, :product_id)
  end
  
end
