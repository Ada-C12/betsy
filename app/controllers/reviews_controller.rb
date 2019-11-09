class ReviewsController < ApplicationController
  before_action :find_product

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.product = @product
    if @review.save
      flash[:success] = "Review added successfully"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:failure] = "A problem occurred: Could not submit your Review"
      puts "failed review"
      render :new, status: :bad_request
      return
    end
  end

  private

  def review_params
    return params.require(:review).permit(:rating, :name, :text)
  end

  def find_product
    @product = Product.find_by_id(params[:product_id])
  end
end
