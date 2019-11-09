class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :toggle_active, :toggle_inactive, :add_product_to_cart]

  def index
    if params[:merchant_id]
      merchant = Merchant.find_by(id: params[:merchant_id])
      if merchant == nil
        return head :not_found
      else
        @products = merchant.products
      end
    elsif params[:category_id]
      category = Category.find_by(id: params[:category_id])
      if category == nil
        return head :not_found
      else
        @products = category.products
      end
    else
      @products = Product.where(status: true)
    end
  end

  def new
    if @login_merchant.nil?
      flash[:status] = :failure
      flash[:result_text] = "Only logged in merchants can create products"
      redirect_to root_path
    else
      @product = @login_merchant.products.new
    end
    if @login_merchant
      merchant = Merchant.find_by(id: params[:merchant_id])
      @products = Product.new
    else
      @product = Product.new
    end
  end

  def create
    if @login_merchant
      @product = Product.new(product_params)

      @product.merchant_id = session[:user_id]
      if @product.save
        flash[:status] = :success
        flash[:result_text] = "Product has been successfully created"
        redirect_to merchant_path(@login_merchant)
      else
        flash[:status] = :failure
        flash[:result_text] = "Invalid product info. Please try again."
        render :new, status: :bad_request
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Only logged in merchants can create products"
      render :new, status: :bad_request
    end
  end

  def show; end

  def edit
    if @login_merchant && @login_merchant.id == @product.merchant_id
      @product = Product.find_by(id: params[:id])
    else
      flash[:status] = :failure
      flash[:result_text] = "Only logged in merchants can edit their own products"
      redirect_to root_path
    end
  end

  def update
    if @login_merchant && session[:user_id] == @product.merchant_id
      if @product.update(product_params)
        flash[:status] = :success
        flash[:result_text] = "Product has been successfully updated"
        redirect_to product_path(@product)
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Only logged in merchants can update products"
      render :edit, status: :not_found
    end
  end

  def toggle_active
    if @login_merchant
      if @product.merchant_id == @login_merchant.id && @product.status == false
        @product.status = true
        @product.save
        return redirect_to merchant_path(session[:user_id])
      else
        flash[:status] = :failure
        flash[:result_text] = "You may only change the status of your own products"
      end
    end
    redirect_to merchant_path(session[:user_id])
  end

  # end

  def toggle_inactive
    if @login_merchant
      if @product.merchant_id == @login_merchant.id && @product.status == true
        @product.status = false
        @product.save
        return redirect_to merchant_path(session[:user_id])
      else
        flash[:status] = :failure
        flash[:result_text] = "You may only change the status of your own products"
      end
    end
    redirect_to merchant_path(session[:user_id])
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :merchant_id, :description, :photo_url, :status, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end
end
