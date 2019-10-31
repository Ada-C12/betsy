require 'pry'
class OrderItemsController < ApplicationController
  def create
    product = Product.find_by(id: params[:product_id])
    if product.nil?
      return head :not_found 
    end
    
    @order_item = OrderItem.new(order_items_params)

    @order_item.shipped = false
    @order_item.product = product

    if @order_item.updated_stock < 0
      flash[:error] = "Cannot add to cart. There are not enough #{@order_item.product.name}s in stock."
      return redirect_to product_path(@order_item.product.id)
    end
    
    if session[:order_id].nil?
      # cancels pending orders that are no longer in session and over a day old
      # Order.cancel_abandoned_orders
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

    @order_item.order = order
    
    if @order_item.save
      flash[:success] = "Item added to cart!"
      order.order_items << @order_item
      return redirect_to product_path(@order_item.product.id)
    else
      flash[:error] = "A problem occurred: Could not add item to cart"
      return redirect_to product_path(@order_item.product.id)
    end
  end

  def update
    order = Order.find_by(id: session[:order_id])
    order_item = OrderItem.find_by(id: params[:id])

    if order_item.nil?
      return head :not_found
    elsif order_item.update(order_items_params)
      flash[:success] = "Successfully updated #{order_item.product.name} quantity to #{order_item.quantity}"
      return redirect_to cart_path
    else
      flash[:error] = "A problem occurred: Could not update #{order_item.product.name} quantity"
      return redirect_to cart_path
    end
  end

  def shipped
    order_item = OrderItem.find_by(id: params[:id])
    
    if order_item.nil?
      return head :not_found
    elsif order_item.order.status != "paid"
      flash[:error] = "Order is not paid: Could not ship #{order_item.product.name}"
      return redirect_back(fallback_location: wizard_path)
    elsif order_item.update_attributes(shipped: true)
      # completes order if all items shipped
      order_item.order.complete_order
      flash[:success] = "Successfully shipped #{order_item.quantity} of #{order_item.product.name}."
      return redirect_back(fallback_location: wizard_path)
    else
      flash[:error] = "A problem occurred: Could not ship #{order_item.product.name}"
      return redirect_back(fallback_location: wizard_path)
    end
  end

  def destroy
    order = Order.find_by(id: session[:order_id])
    order_item = OrderItem.find_by(id: params[:id])

    if order_item.nil?
      return head :not_found
    else
      order_item.destroy
      flash[:success] = "Removed #{order_item.product.name} from cart"
      return redirect_to cart_path
    end
  end

  private

  def order_items_params
    params.require(:order_item).permit(:quantity)
  end
end
