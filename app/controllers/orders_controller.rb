class OrdersController < ApplicationController
  def show
    # find current order in session
    @order = Order.find_by(id: session[:cart_id])
    
  end

  def new
    if session[:cart_id].nil?
      @order = Order.new
      session[:cart_id] = @order.id
    else
      @order = Order.find_by(id: session[:cart_id])
    end
  end

  def create
  end

  def destroy
  end

end

