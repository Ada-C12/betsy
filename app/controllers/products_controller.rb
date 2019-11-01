class ProductsController < ApplicationController
  before_action :require_login, except: [:index, :show, :review]
  
  def index
    @users = User.all.order(:id)
    @categories = Category.all

    @merchant_id = params[:merchantId]

    if @merchant_id
      @products  = Product.where(user_id: @merchant_id)
    else
      @products = Product.all
    end

    @category_id = params[:categoryId]
    if @category_id
      @products = Product.joins(:categories).where(:categories => {id: @category_id})
    end
  end 

  def show
    product_id = params[:id].to_i
    @product = Product.find_by(id:params[:id])
    if @product.nil?
      head :not_found 
    end
    @order_item = OrderItem.new(order_id: get_cart[:order_id])
  end 

  def new
    @product = Product.new
  end 

  def create
    @product = Product.new(product_params.merge({user_id: @login_user.id}))
    
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "New product added."
      redirect_to dashboard_path(item: 'products')
      return
    else
      flash[:status] = :failure
      flash[:result_text] = "Fail to add new product"
      render new_product_path
    end
  end 

  def edit
    @product = Product.find_by(id: params[:id])
    @categories = Category.select(:label).map(&:label)

    
    if @product.nil?
      head :not_found
    elsif @product.user_id != @login_user.id
      flash[:status] = :failure
      flash[:result_text] = "You do not have permission to edit this product."
      redirect_to product_path(@product.id)
    end
  end 

  def update
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      head :not_found
      return
    elsif @product.user_id != @login_user.id
      flash[:status] = :failure
      flash[:result_text] = "You do not have permission to update this product."
      redirect_to product_path(@product.id)
      return 
    else
      @product.update(product_params)
     
      flash[:status] = :success
      flash[:result_text] = "Product updated."
      redirect_to dashboard_path(item: 'products')
    end
  end

  def review
    @product = Product.find_by(id: params[:id])

    if session[:user_id] == @product.user_id 
      flash[:status] = :failure
      flash[:result_text] = "You can't review your own product"
      redirect_to product_path(@product.id)
    elsif session[:user_id].nil?
      @product.reviews.create(review_params.merge({user_id: 0, product_id: @product.id}))

      flash[:status] = :success
      flash[:result_text] = "Thanks for your review!"
      redirect_to product_path(@product.id)
    else 
      @product.reviews.create(review_params.merge({user_id: @login_user.id, product_id: @product.id}))

      flash[:status] = :success
      flash[:result_text] = "Thanks for your review!"
      redirect_to product_path(@product.id)
    end 
  end 

  private
  
  def product_params
    return params.require(:product).permit(:stock, :name, :description, :photo_url, :price, :retired, :category_ids => [])
  end

  def review_params
    return params.permit(:rating, :user_review)
  end

  def require_login
    if find_user.nil?
      flash[:status] = :failure
      flash[:error] = "You must be logged in to view this."
      redirect_to products_path
    end 
  end 
end