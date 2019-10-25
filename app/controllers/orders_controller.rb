class OrdersController < ApplicationController
  skip_before_action :require_login
  
  def show
    @order = Order.find_by(id: params[:id]])
    if @order.nil?
      flash[:error] = "Order doesn't exist!"
      redirect_to root_path
    end
  end
  
  def cart
    if session[:cart_id].nil?
      @order = Order.create(status: "pending")
      session[:cart_id] = @order.id
    else
      @order = Order.find_by(id: session[:cart_id])
      if @order.nil?
        flash[:error] = "Order doesn't exist!"
        redirect_to root_path
      end
    end
  end
  
  def create
    @order = Order.update(order_params)
    @order.status = "paid"
    @order.customer_id = session[:user_id]
    if @order.save
      session[:cart_id] = nil
      flash[:success] = "Order #{@order.id} has been successfully created!"
      redirect_to order_path(@order.id)
    else
      flash[:error] = "Something went wrong! Order was not paid."
      render cart_path
    end
  end
  
  def destroy
  end
  
  private

  def order_params
    return params.require(:order).permit(:name, :email, :address, :cc_name, :cc_last4, :cc_exp, :cc_cvv, :billing_zip)
  end
  
end

