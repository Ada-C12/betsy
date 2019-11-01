class ProductsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  
  def index
    @products = Product.where(status: "active")
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    @product.user_id = session[:user_id]
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "#{@product.name} successfully saved!"
      redirect_to product_path(@product.id)
    else
      flash.now[:status] = :warning
      flash.now[:result_text] = "Product not successfully saved"
      render :new
    end
  end
  
  def show
    product_id = params[:id].to_i
    @product = Product.find_by(id: product_id)
    if @product.nil?
      flash[:status] = :warning
      flash[:result_text] = "Product not found"
      redirect_to products_path
    end
  end
  
  def edit
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:status] = :warning
      flash[:result_text] = "That product does not exist"
      redirect_to products_path
      return
    end
    if @product.user_id != session[:user_id]
      flash[:status] = :warning
      flash[:result_text] = "You do not have permission to edit this product"
      redirect_to product_path(@product.id)
      return
    end
  end
  
  def update
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:status] = :warning
      flash[:result_text] = "That product does not exist"
      redirect_to products_path
      return
    elsif @product.update(product_params)
      flash[:status] = :success
      flash[:result_text] = "#{@product.name} successfully updated!"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:status] = :warning
      flash.now[:result_text] = "#{@product.name} not successfully updated!"
      render :edit
    end
  end
  
  private
  def product_params
    return params.require(:product).permit(:name, :qty, :price, :description, :photo_url, :status, category_ids: [])
  end
end
