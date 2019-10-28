class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end
  
  def create
    @review = Review.new(media_params)
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Thank you! Your review has been saved."
      redirect_back fallback_location: root_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not save your review. Please check below and submit again."
      flash.now[:messages] = @review.errors.messages
      render :new, status: :bad_request
    end
  end
  
  private
  
  def media_params
    params.require(:work).permit(:title, :category, :creator, :description, :publication_year)
  end
end

