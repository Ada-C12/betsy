class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update, :destroy]
  
  def show
    # If you don't have an order_id, you haven't added anthing to cart.
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
      
      # This is the nice redirect not found carts.
      if @order.nil?
        flash[:status] = :failure
        flash[:result_text] = "Unable to load cart at this time. Please refresh and try again."
        redirect_back fallback_location: root_path
        return
      end
    else
      # This is the nice redirect for average users with empty carts.
      # Theoretically would render a dummy cart page 
      flash[:status] = :failure
      flash[:result_text] = "No items currently in cart."
      redirect_back fallback_location: root_path
      return
    end
  end
  
  def edit ; end
  
  def update
    # Smart but needs to be tested. 
    # Will your status update along with your order params.
    @order.status = "paid"
    
    if @order.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Order confirmed. We are working on your order!"  
      
      redirect_to order_path(@order.id)
      return 
    else 
      flash.now[:status] = :failure
      flash.now[:result_text] = "Please check the following information and submit again."
      flash.now[:messages] = @order.errors.messages
      
      render :edit, status: :bad_request  
      return
    end
  end
  
  def cancel
    @order.status = "cancelled"
    
    if @order.save
      flash[:status] = :success
      flash[:result_text] = "Your order has been cancelled."
      
      redirect_to root_path
      return
    else
      flash[:status] = :failure
      flash[:result_text] = "Something went wrong. Could not cancel order."
      flash[:messages] = @order.errors.messages
      
      redirect_back fallback_location: root_path
      return
    end
  end
  
  private 
  
  def order_params
    params.require(:order).permit(:email, :address, :cc_name, :cc_num, :ccv, :cc_exp, :zip)
  end
  
  def find_order
    @order = Order.find_by(id: session[:order_id])
    
    if @order.nil?
      head :not_found
      return
    end
  end
  
end
