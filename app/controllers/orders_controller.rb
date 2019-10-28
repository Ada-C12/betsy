class OrdersController < ApplicationController
  before_action :find_order_from_session, only: [:edit, :update]
  before_action :find_order_from_params, only: [:show, :cancel]
  
  def cart
    # If you don't have an order_id, you haven't added anthing to cart.
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
      
      if @order.nil?
        head :not_found
        return
      end
    else
      # This is the nice redirect for average users with empty carts.
      # Theoretically sdj render a dummy cart page 
      flash[:status] = :failure
      flash[:result_text] = "No items currently in cart."
      redirect_back fallback_location: root_path
      return
    end
  end
  
  def edit ; end
  
  def update
    @order.orderitems.each do |orderitem|
      if !orderitem.valid?
        flash.now[:status] = :failure
        flash.now[:result_text] = "Sorry. Some of the items in your cart are no longer available."
        flash.now[:messages] = orderitem.errors.messages
        
        # NOT SURE HOW TO CHAIN ERROR MESSAGES TOGETHER, WILL NEED TO GO THROUGH THEM ONE BY ONE
      end
      
      if flash.now[:status] == :failure
        return render :edit, status: :bad_request 
      end
    end
    
    # Stage the status to be "paid"
    @order.status = "paid"
    
    if @order.update(order_params)
      # Reduce the inventory or all ordered products
      @order.reduce_stock
      
      # Clears the current cart
      session[:order_id] = nil
      
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
  
  def show 
    if @order.status == "pending"
      flash[:status] = :failure
      flash[:result_text] = "Cannot cancel #{@order.status} orders."
      flash[:messages] = @order.errors.messages
      
      redirect_to root_path
      return
    end
  end
  
  def cancel
    unless @order.status == "paid"
      flash[:status] = :failure
      flash[:result_text] = "Cannot cancel #{@order.status} orders."
      flash[:messages] = @order.errors.messages
      
      redirect_to root_path
      return
    end
    
    @order.status = "cancel"
    
    if @order.save
      flash[:status] = :success
      flash[:result_text] = "Your order has been cancelled."
      
      # Returns all previously purchased inventory to product stock
      @order.return_stock
      
      redirect_to order_path(@order.id)
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
    params.require(:order).permit(:email, :address, :cc_name, :cc_num, :cvv, :cc_exp, :zip)
  end
  
  def find_order_from_session
    @order = Order.find_by(id: session[:order_id])
    
    if @order.nil?
      head :not_found
      return
    end
  end
  
  def find_order_from_params
    @order = Order.find_by(id: params[:id])
    
    if @order.nil?
      head :not_found
      return
    end
  end
end
