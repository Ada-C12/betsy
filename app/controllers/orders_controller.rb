class OrdersController < ApplicationController
  skip_before_action :require_login, only: [:cart, :checkout, :update, :confirmation]
  
  def show
    @order = Order.find_by(id: params[:id])
    if @order.contain_orderitems?
      if @order.nil?
        flash[:error] = "Order doesn't exist!"
        return redirect_to root_path 
      end
    else
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
    end
  end
  
  def update
    @current_order = Order.update(order_params)
    @current_order.status = "paid"
    @current_order.customer_id = session[:user_id]
    if @current_order.save
      return redirect_to confirmation_path
    else
      flash[:error] = "Something went wrong! Order was not paid."
      render cart_path
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
  
  private
  
  def order_params
    return params.require(:order).permit(:name, :email, :address, :cc_name, :cc_last4, :cc_exp, :cc_cvv, :billing_zip, :status)
  end
  
end

