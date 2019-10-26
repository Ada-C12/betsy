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
        flash[:success] = "Order Created"
        redirect_back(fallback_location: :back)
        return
      else
        redirect_to root_path
        flash[:error] = "Error creating order SOMETHING IS WRONG HEREEE"
        return
      end

    else
      order = Order.find_by(id: session[:order_id])
      order.order_items << @order_item
    end
    
    
    @order_item.shipped = false
    @order_item.product = product
    @order_item.save
    @order_item.order = order
    
    if @order_item.save
      flash[:success] = "Item added to cart!"
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
