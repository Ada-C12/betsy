class ReviewsController < ApplicationController
  def new
    if params[:product_id]
      @review = Review.new(product_id: params[:product_id])
    end
  end

  def create
  
    product = Product.find_by(id: params[:product_id])
    unless product 
      head :not_found 
      return 
    end 
    @review = Review.new(review_params)
    @review.product = Product.find_by(id: product.id)
    
    if @review.save
      flash[:success] = "Successfully Reviewed #{product.name}"
      redirect_to product_path(product.id)
      return 
    else
      render :new
      return 
    end
  

  end

  private

  def review_params
    return params.require(:review).permit(:rating,:review_comment)
  end
end
