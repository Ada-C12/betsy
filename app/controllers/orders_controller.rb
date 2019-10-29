class OrdersController < ApplicationController
  skip_before_action :require_login, only: [:cart, :checkout, :update]
  
  
  def cart
    @items = @current_order.order_items 
  end
  
  def show
    @order = Order.find_by(id: params[:id])
    @user = User.find_by(id: session[:user_id])
    user_items = @order.order_items.select { |item| item.product.user_id == @user.id }
    if !user_items.nil?
      @items = user_items
    end
  end
  
  def edit
    @order = Order.find_by(id: params[:id])
  end
  
  def update
    
    @order = Order.find_by(id: params[:id])
    
    if @order.update(order_params)
      if @order.status == "complete"
        flash[:status] = :success
        flash[:result_text] = "Successfully updated status!"
        redirect_to order_path(@order.id)
      else
        flash[:status] = :success
        flash[:result_text] = "Successfully completed order!"
        session[:order_id] = nil
        redirect_to root_path
      end
    else
      flash[:status] = :error
      flash[:result_text] = "A problem occured: Could not update order status"
      redirect_to order_path(@order.id)
    end
  end
  
  def checkout
    @order = @current_order
  end
  
  
  # def complete

  #   @order = Order.find_by(order_params)
  #   @order.status = "paid"
    
  #   if @order.update(status: params[:status])
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully checked out!"
  #     redirect_to root_path
  #   else
  #     flash.now[:status] = :error
  #     flash.now[:result_text] = "A problem occured: Could not complete order"
  #     render :checkout
  #   end
  # end
  
  private
  
  def order_params
    return params.require(:order).permit(:name, :email, :address, :ccnum, :expdate, :ccv, :zip)
  end
  
end
