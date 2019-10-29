class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update]
  
  def new
    @order = Order.new
  end
  
  def create
    @order = Order.new(order_params)
    
    if @order.save
      flash[:success] = "Order #{@order.id} created successfully"
    else
      flash.now[:error] = "You ARE BAD."
    end
    
    redirect_to order_path(@order.id)
  end
  
  def edit
  end
  
  def update
    if @order     
      
      if @order.update(order_params) # update certain attributes instead of everything at once
        flash[:success] = "order updated!"
        redirect_to order_path(@order.id)
        return
      end
      flash.now[:error] = "Required fields cannot be blank!"
      render :edit
      return
    end
  end
  
  def destroy
    order = Order.find_by(id: params[:id])
    if order 
      flash[:success] = "Order deleted!"
      order.destroy
    else
      flash[:error] = "That order doesn't exist!"
    end
    
    redirect_to root_path
    return
  end
  
  private
  
  def order_params
    return params.require(:order).permit(:buyer_email, :buyer_address, :buyer_name, :buyer_card, :card_expiration, :cvv, :zipcode, :status)
  end
  
  def find_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "That order does not exist"
      redirect_to root_path
    end
  end
end
