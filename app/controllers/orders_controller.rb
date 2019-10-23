class OrdersController < ApplicationController

  def index
    @orders = Orders.all
  end

  def new
    @order = Order.new
  end
  
  def show
    #need to add merchant login?
    @order = Order.find_by(id: params[:id])
    #flash error if no
    
  end
  
  def create
    @order = Order.new

  end
  
  def update
    @order = Order.find_by(id: params[:id])
  end

  def purchase

  end
  
  def confirmation
    @order = Order.find_by(id: params[:id])
  end

  private 

  def order_params

  end

end
