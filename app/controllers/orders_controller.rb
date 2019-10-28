class OrdersController < ApplicationController
  skip_before_action :require_login, only: [:cart, :checkout, :update, :confirmation]
  
  def show
    @order = Order.find_by(id: params[:id])
    if !@order
      head :not_found 
    elsif !@order.contain_orderitems?
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
    else
    end
  end
  
  def update_paid
    @current_order.update(order_params)
      @current_order.status = "paid"
      @current_order.customer_id = session[:user_id]
      
      if @current_order.save
        flash[:success] = "Order #{@current_order.id} has been purchased successfully!"
        return redirect_to confirmation_path
      else
        flash.now[:error] = "Something went wrong! Order was not paid.#{@current_order.errors.messages}"
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
    return params.require(:order).permit(:name, :email, :address, :cc_name, :cc_last4, :cc_exp, :cc_cvv, :billing_zip)
  end
  
end

