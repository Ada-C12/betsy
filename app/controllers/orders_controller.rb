class OrdersController < ApplicationController
  skip_before_action :require_login, only: [:cart, :checkout, :update_paid, :confirmation]
  skip_before_action :find_order, only: [:show, :update_paid, :cancel_order, :complete_order]
  before_action :find_order_params, only: [:show, :update_paid, :cancel_order, :complete_order]
  
  def show
    if !@order
      head :not_found 
      return 
    elsif !@order.contain_orderitems?(@current_user)
      flash[:error] = "You cannot check this order details!"
      return redirect_to root_path 
    end
  end
  
  def cart
  end
  
  def checkout
    if @current_order.nil?
      flash[:error] = "Order doesn't exist!"
      return redirect_to root_path
    elsif @current_order.order_items.empty?
      flash[:error] = "No item in the cart! Please add some items then checkout!"
      return redirect_to root_path
    end
  end
  
  def update_paid
    @order.update(order_params)
    @order.customer_id = session[:user_id]
    @order.status = "paid"
    
    if @order.save
      flash[:success] = "Order #{@order.id} has been purchased successfully!"
      return redirect_to confirmation_path
      
    else
      @order.update(status: "pending")
      flash[:error] = "Something went wrong! Order was not paid.#{@order.errors.messages}"
      redirect_to cart_path
      return
    end
  end
  
  def confirmation
    if @current_order
      session[:cart_id] = nil
      flash[:success] = "Order #{@current_order.id} has been successfully created!"
    else
      flash[:error] = "Order doesn't exist!"
      return redirect_to root_path
    end
  end
  
  def cancel_order
    if !@order
      flash[:error] = "Something went wrong, cannot cancel order!"
    else
      if @order.contain_orderitems?(@current_user)
        previous_status = @order.status
        @order.status = "cancelled"
        if @order.save
          flash[:success] = "Order #{@order.id} has been cancelled successfully!"
        else
          @order.update(status: previous_status)
          flash[:error] = "Something went wrong, order is not cancelled!"
        end
      else
        flash[:error] = "You're not allowed to cancel this order!"
      end
    end
    return redirect_to current_user_path 
  end
  
  def complete_order
    if !@order
      flash[:error] = "Something went wrong, cannot complete order!"
    else
      if @order.contain_orderitems?(@current_user)
        previous_status = @order.status
        @order.status = "completed"
        if @order.save
          flash[:success] = "Order #{@order.id} has been completed successfully!"
        else
          @order.update(status: previous_status)
          flash[:error] = "Something went wrong, order is not completed!"
        end
      else
        flash[:error] = "You're not allowed to complete this order!"
      end
    end
    return redirect_to current_user_path 
  end
  
  private
  
  def order_params
    return params.require(:order).permit(:name, :email, :address, :cc_name, :cc_last4, :cc_exp, :cc_cvv, :billing_zip, status: "paid")
  end
  
  def find_order_params
    @order = Order.find_by(id: params[:id])
  end
  
end

