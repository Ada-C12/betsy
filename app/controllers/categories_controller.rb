class CategoriesController < ApplicationController

  def show
    category_id = params[:id]
    @category = Category.find_by(id: category_id)

    if @category.nil?
      redirect_to root_path
    end
  end

  def new
    if session[:merchant_id].nil?
      flash[:warning] = "You must be logged in as a merchant to add a product."
      redirect_to root_path
      # redirect_back(fallback_location: root_path)
      return
    end
    @category = Category.new
  end

  def create
    @category = Category.new(name: params[:category][:name])
    if @category.save 
      flash[:success] = "Your category has been added."
      redirect_to root_path
      return
    else 
      flash.now[:warning] = "Your category could not be saved because #{@category.errors.full_messages}"
      render :new
      return
    end
  end 
end
