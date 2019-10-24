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
  end

  # only merchants
  def edit
  end 

  # only merchants
  def create
  end

  # only merchants
  def update
  end

  # only merchants
  def destroy
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :photo_url, :stock, :merchant)
  end


  # def require_login
  # end

end
