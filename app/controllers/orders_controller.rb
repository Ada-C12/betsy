class OrdersController < ApplicationController
  
  def index
    @orders = Orders.all
  end
  
  def new
    @order = Order.new(order_params)
  end
  
  #need to add merchant login
  #for views of:
  #merchant logged in
  #guest user 
  #super not sure about thiiiis :|
  def show
    if @merchant_logged_in 
      @order = Order.find_by(id: params[:id])
    elsif
      if @order = nil 
        redirect_to login_path
      else
        flash[:error] = "You must be logged in to see this page" #if merchant isnt logged in
        redirect_to root_path #to login
      end
    end
  end
  
  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to confirmation_path
      return 
    else 
      render :new
    end
  end
  
  #order items get added to cart
  def current_order
    if session[:order_id]
      Order.find(session[:order_id])
    else
      Order.new
    end
  end 
  
  def cart
    @current_order = order_items
  end
  
  def update
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      head :not_foiund
      return
    end
    if @order.update(order_params)
      redirect_to order_path(@order.id)
      return 
    else 
      render order_path
    end
  end
  
  #order when officially purchased
  def confirmation
    @order = Order.find_by(id: params[:id])
  end
  
  #to toggle between shipped and not shipped
  def order_shipped
    order_id = params[:id]
    @order = Order.find_by(id: params[:id])
    if @order.shipped == true
      @order.shipped = false
      @order.save 
    else
      @order.shipped == false
      @order.shipped = true
      @order.save 
    end
    redirect_to orders_path
  end
  
  private 
  
  def order_params
    params.require(:order).permit(:email, :address, :cc_name, :cc_num, :ccv, :cc_exp, :zip, :status)
  end
  
  # def find_order
  #   @order = Order.find_by(id: params: [id])
  # end
  
end
