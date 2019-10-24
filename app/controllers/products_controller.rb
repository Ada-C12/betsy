class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    end
  end

  def new
    if !session[:user_id]
      flash[:error] = "Merchant must login to add a new product!"
      redirect_to root_path
    else
      @product = Product.new
    end
  end

  def create
    if !session[:user_id]
      flash[:error] = "Merchant must login to add a new product!"
      redirect_to root_path
    else
      @product = Product.new(product_params)
      if @product.save
        flash[:success] = "Product #{@product.name} has been added successfully"
        redirect_to product_path(@product.id)
      else
        flash.now[:error] = "Something went wrong! Product was not added."
        render :new
      end
    end
  end

  def edit
    if !session[:user_id]
      flash[:error] = "Merchant must login to edit product!"
      redirect_to root_path
    else
      @product = Product.find_by(id: params[:id])
    end
  end

  def update
    if !session[:user_id]
      flash[:error] = "Merchant must login to update product!"
      redirect_to root_path
    else
      if @product.update(product_params)
        flash[:success] = "Product #{@product.name} has been updated successfully"
        redirect_to product_path(@product.id)
      else
        flash.now[:error] = "Something went wrong! Product can not be edited."
        render :edit
      end
    end
  end

  def destroy
    if !session[:user_id]
      flash[:error] = "Merchant must login to delete a product!"
      redirect_to root_path
    else
      product = Product.find_by(id: params[:id])
      
      if product
        if product.user_id == session[:id]
          product.destroy
          flash[:success] = "Product #{product.name} was deleted!"
        else
          flash[:error] = "You cannot delete a product not belonging to you!"
        end 
      else
        flash[:error] = "The product doesn't exist!"
      end

    end
    redirect_to products_path
    return
  end

  private

  def product_params
    return params.require(:product).permit(:name, :category_ids, :price, :quantity, :user_id, :img_url, :description)
  end
end
