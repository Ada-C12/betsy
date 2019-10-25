class OrderItemsController < ApplicationController

  def create
    product = Product.find_by(id: params[:product_id])
    if product.nil?
      return head :not_found 
    end

    unless session[:order_id]
      order = Order.create
    else
      order = Order.find_by(id: session[:order_id])
    end

    @order_item = OrderItem.new(order_items_params)
    @order_item.shipped = false
    @order_item.product = product
    @order_item.order = order
    @order_item.save

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
