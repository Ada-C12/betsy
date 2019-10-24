class ProductsController < ApplicationController
  # before_action :require_login, except [:index]
  
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


    p @product.inspect
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@product} #{@product.id}"
      redirect_to product_path(@product)
    else
      p @product.errors.messages
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product}"
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  # only merchants
  def edit
  end 

  # only merchants
  def update
  end

  # only merchants
  def destroy
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :photo_url, :stock, :merchant_id)
  end


  # def require_login
  # end

end
