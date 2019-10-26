class OrdersController < ApplicationController
  def cart
    @order = Order.find_by(id: session[:order_id])
    
  end
  # checkout form will be the edit form
  
  # checkout button will be the update action
    #remove from session session[:order_id] = nil
end
