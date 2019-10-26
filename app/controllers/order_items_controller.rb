class OrderItemsController < ApplicationController
  
  def create
    product = Product.find_by(id: params[:product_id])
    if product.nil?
      return head :not_found 
    end
    
    @order_item = OrderItem.new(order_items_params)
    
    if session[:order_id].nil?
      order = Order.new(status: 'pending')
      if order.save
        session[:order_id] = order.id
      else
        flash[:error] = "Error creating order SOMETHING IS WRONG HEREEE"
        return redirect_to root_path
      end

    else
      order = Order.find_by(id: session[:order_id])
      if order.nil?
        flash[:error] = "Sorry, this order has been deleted"
        session[:order_id] = nil
        return redirect_to root_path
      end
    end 
    
    @order_item.shipped = false
    @order_item.product = product
    @order_item.order = order
    
    if @order_item.save
      flash[:success] = "Item added to cart!"
      order.order_items << @order_item
      redirect_back(fallback_location: :back)
      return
    else
      flash[:error] = "A problem occurred: Could not add item to cart"
      redirect_back(fallback_location: :back)
      return
    end
  end
  
  def order_items_params
    params.require(:order_item).permit(:quantity)
  end
end
