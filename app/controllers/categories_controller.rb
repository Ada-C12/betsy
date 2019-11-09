class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Category added successfully"
      redirect_to root_path
    else
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end
end
