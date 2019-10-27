class ProductsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  
  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:error] = "Product doesn't exist"
      redirect_to root_path
      return
    end
  end 

  # only merchants
  def new
    @product = Product.new
  end

  # only merchants
  def create
    @product = Product.new(product_params)
    @merchant = Merchant.find_by(id: session[:merchant_id])
    @product.merchant_id = @merchant.id 
    @product.retired = false
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@product.name} #{@product.id}"
      redirect_to product_path(@product)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product.name}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  # only merchants
  def edit
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      flash[:status] = :failure
      flash[:result_text] = "#{@product} doesn't exist."
      redirect_to products_path
    end
  end 

  # only merchants
  def update
    @product = Product.find_by(id: params[:id])
    @product.update_attributes(product_params)
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.name}"
      redirect_to product_path(@product)
    else 
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update #{@product.name}"
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :bad_request
    end
  end

  # only merchants
  def toggle_retire
    @product = Product.find_by(id: params[:id])
    if @product.retired == true
      @product.retired = false
      @product.save
    elsif @product.retired == false
      @product.retired = true
      @product.save
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :photo_url, :stock, :retired)
  end
end
