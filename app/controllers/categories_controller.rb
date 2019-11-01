class CategoriesController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  
  def index
    @categories = Category.all
  end
  
  def show
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      head :not_found
      return
    end
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new( category_params )
    if @category.save
      flash[:status] = :success
      flash[:result_text] = "#{@category.name} successfully saved!"
      redirect_to category_path(@category.id)
    else
      flash.now[:status] = :error
      flash.now[:result_text] = "Category not successfully saved"
      render :new
    end
  end
  
  def edit
    @category = Category.find_by(id: params[:id] )
    if @category.nil?
      flash[:status] = :error
      flash[:result_text] = "That category does not exist"
      redirect_to categories_path
      return
    end
  end
  
  def update
    @category = Category.find_by(id: params[:id] )
    if @category.nil?
      flash[:status] = :error
      flash[:result_text] = "That category does not exist"
      redirect_to categories_path
      return
    elsif @category.update( category_params )
      flash[:status] = :success
      flash[:result_text] = "#{@category.name} successfully updated!"
      redirect_to category_path(@category.id)
    else
      flash.now[:status] = :error
      flash.now[:result_text] = "#{@category.name} not successfully updated!"
      render :edit
    end
  end
  
  private             
  
  def category_params
    return params.require(:category).permit(:name)
  end
end
