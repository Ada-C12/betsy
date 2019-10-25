class OrdersController < ApplicationController
  def create
    @order = Order.new(status: pending)
    
    if @order.save
      session[:order_id] = @order.id
      flash[:success] = "Order Created"
      redirect_back(fallback_location: :back)
      return
    else
      redirect_to root_path
      flash[:error] = "Error creating order SOMETHING IS WRONG HEREEE"
      return
    end
    
    
  end
  
  
  # checkout form will be the edit form
  
  # checkout button will be the update action
end
