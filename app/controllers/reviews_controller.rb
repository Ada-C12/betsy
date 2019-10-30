
class ReviewsController < ApplicationController
  def new
    product = Product.find_by(id: params[:product_id])

    if product
      if session[:wizard_id] == product.wizard.id
        flash[:error] = "You can't review your own product"
        redirect_to product_path(product.id)
      end
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
    @review.product = product

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
    return params.require(:review).permit(:rating, :review_comment)
  end
end
