

class ReviewsController < ApplicationController
  def new
    
    if params[:product_id]
      @review = Review.new(product_id: params[:product_id])
    end
  end

  def create
 
    product = Product.find_by(id: params[:product_id])
    @review = Review.new(review_params)
    @review.product = Product.find_by(id: product.id)

    if @review.save
      redirect_to product_path(product.id)
    else
      render :new
    end

  end

  private

  def review_params
    return params.require(:review).permit(:rating)
  end
end
