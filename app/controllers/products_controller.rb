class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]
  skip_before_action :require_login, :only => [:index, :show]
  skip_before_action :find_order

  def index
    category_id = params[:category_id]
    user_id = params[:user_id]

    if category_id.nil? && user_id.nil?
      @products = Product.all
    elsif category_id
      @category = Category.find_by(id: category_id)
      if @category
        @products = @category.products
      else
        head :not_found
      end
    elsif user_id
      @user = User.find_by(id: user_id)
      if @user
        @products = @user.products
      else
        head :not_found
      end
    else
      head :not_found
    end
  end
  
  def show
    if @product.nil?
      head :not_found
      return
    end
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    @product.user_id = session[:user_id]
    
    if @product.save
      flash[:success] = "Product #{@product.name} has been added successfully"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something went wrong! Product was not added."
      render :new
      return
    end
  end
  
  def edit
    if @product.nil?
      redirect_to root_path
      return
    end
  end
  
  def update
    if @product.update(product_params)
      flash[:success] = "Product #{@product.name} has been updated successfully"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something went wrong! Product can not be edited."
      render :edit
      return
    end
  end
  
  def destroy
    product = Product.find_by(id: params[:id])
    if product
      if product.user_id == session[:user_id]
        product.destroy
        flash[:success] = "Product #{product.name} was deleted!"
      else
        flash[:error] = "You cannot delete a product not belonging to you!"
      end
    else
      flash[:error] = "The product doesn't exist!"
    end
    
    redirect_to root_path
    return
  end
  
  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(:name, :price, :quantity, :img_url, :description, category_ids: [])
  end
end
