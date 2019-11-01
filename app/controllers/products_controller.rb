class ProductsController < ApplicationController
  
  def index 
    @products = Product.where(retire: false)
  end
  
  def show 
    product_id = params[:id]
    @product = Product.find_by(id: product_id)
    
    if @product.nil?
      flash[:warning] = "Product with id #{params[:id]} was not found!"
      redirect_to products_path
    end
  end
  
  def new
    if session[:merchant_id].nil?
      flash[:warning] = "You must be logged in as a merchant to add a product."
      redirect_back(fallback_location: root_path)
      return
    end
    
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params.merge(merchant_id: session[:merchant_id])) # merge product params with session based ones
    if @product.save 
      flash[:success] = "Your product has been added."
      redirect_to merchant_path(session[:merchant_id])
      return
    else 
      flash.now[:danger] = "Your product could not be saved because #{@product.errors.full_messages}"
      render :new
      return
    end
  end
  
  def edit 
    @product = Product.find_by(id:params[:id])
    
    if @product.nil?
      redirect_to root_path
      return
    end
    
    if session[:merchant_id].nil?
      flash[:warning] = "You must be logged in as a merchant to edit a product."
      redirect_back(fallback_location: root_path)
      return
    elsif session[:merchant_id] != @product.merchant.id 
      flash[:warning] = "You cannot update another merchant's product(s)"
      redirect_back(fallback_location: root_path)
      return 
    end
  end
  
  def update 
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      redirect_to root_path
    end
    
    if @product.update(product_params.merge(merchant_id: session[:merchant_id]))
      flash[:success] = "You updated a product successfully!"
      redirect_to root_path
    else 
      flash[:warning] = "This product was not updated because #{@product.errors.messages}"
      redirect_to edit_product_path 
      return 
    end
  end 
  
  private 
  
  def product_params
    params.require(:product).permit(:name, :price, :stock, :description, :photo, :retire, category_ids: [])
  end
end
