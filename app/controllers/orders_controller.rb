class OrdersController < ApplicationController
  skip_before_action :require_login, only: [:cart, :checkout, :confirmation, :update]
  
  
  def cart
    @items = @current_order.order_items 
  end
  
  def show
    @order = Order.find_by(id: params[:id])
    
    if @order.nil?
      flash[:status] = :error
      flash[:result_text] = "A problem occured: Could not find order"
      redirect_to root_path
      return
    end
    
    @user = User.find_by(id: session[:user_id])
    user_items = @order.order_items.select { |item| item.product.user_id == @user.id }
    if !user_items.nil?
      @items = user_items
    end
  end
  
  def edit
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:status] = :error
      flash[:result_text] = "A problem occured: Could not find order"
      redirect_to root_path
      return
    end
    
  end
  
  def update
    
    @order = Order.find_by(id: params[:id])
    if params[:status] == "complete"
      @order.update(order_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated status!"
      redirect_to order_path(@order.id)
    elsif @order.status == "pending"
      @order.status = "paid"
      @order.update_qty
      @order.order_place = Time.now
      if @order.update(order_params)
        flash[:status] = :success
        flash[:result_text] = "Successfully completed order!"
        session[:order_id] = nil
        redirect_to confirmation_path
      else
        render :checkout
      end
    else
      flash[:status] = :error
      flash[:result_text] = "A problem occured. Please try again."
      redirect_to request.referrer
    end
  end
  
  def checkout
    @order = @current_order
  end
  
  def update_status
    @order = Order.find_by(id: params[:id])
    @order.status = "complete"
    @order.save
    
    redirect_to request.referrer
  end

  def confirmation
    @order = Order.where(status: "paid").last
    @items = @order.order_items
  end
  
  private
  
  def order_params
    return params.require(:order).permit(:name, :email, :address, :ccnum, :expdate, :ccv, :zip)
  end
  
end
