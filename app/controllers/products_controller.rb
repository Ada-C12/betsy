class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]
  skip_before_action :require_login, :only => [:index, :show]
  skip_before_action :find_order

  def index
    category_id = params[:category_id]

    if category_id.nil?
      @products = Product.active
    elsif category_id
      @category = Category.find_by(id: category_id)
      if @category
        @products = @category.products.active
      else
        head :not_found
      end
    else
      head :not_found
      return
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
      if @current_user.merchant_name.nil?
        flash[:success] = "Product #{@product.name} has been added successfully"
        flash[:message] = "You merchant name is currently empty. Please add a merchant name to add your fruit stand to the Merchants List."
        return redirect_to edit_user_path
      else
        flash[:success] = "Product #{@product.name} has been added successfully"
        redirect_to product_path(@product.id)
        return
      end
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
      redirect_to current_user_path
      return
    else
      flash.now[:error] = "Something went wrong! Product can not be edited."
      render current_user_path 
      return
    end
  end
  
  def destroy
    product = Product.find_by(id: params[:id])
    if product
      if product.user_id == session[:user_id]
        product.destroy
        flash[:success] = "Product #{product.name} was deleted!"
        redirect_to root_path
        return
      else
        flash[:error] = "You cannot delete a product not belonging to you!"
        redirect_to root_path
        return
      end
    else
      flash[:error] = "The product doesn't exist!"
      redirect_to root_path
      return
    end
  end
  
  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(:name, :price, :stock, :img_url, :description, :active, category_ids: [])
  end
end
