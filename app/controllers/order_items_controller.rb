class OrderItemsController < ApplicationController
  def update
    order_item = OrderItem.find_by(id: params[:id])
    
    if order_item
      order_item.quantity = order_item_params[:quantity]
      if order_item.save
        flash[:status] = :success
        flash[:result_text] = "updated #{ order_item.product.name } quantity"
        redirect_to cart_path
      else
        flash[:status] = :failure
        flash[:messages] = order_item.errors.messages
        redirect_to cart_path
      end
    else
      flash[:status] = :failure
      flash[:messages] = { order_item: "not found" }
      redirect_to cart_path
    end
  end
  
  def destroy
    order_item = OrderItem.find_by(id: params[:id])
    if order_item && find_cart.order_items.include?(order_item)
      order_item.delete
      flash[:success] = "removed #{ order_item.product.name }"
      redirect_to cart_path
    else
      flash[:error] = "unable to remove #{ order_item.product.name }"
      flash[:messages] = ["not found"]
      return head :not_found
    end
  end
  
  def mark_shipped
    order_item = OrderItem.find_by(id: params[:id])
    order_item.shipping_status = "shipped"
    order_item.save
    if order_item.save
      order = Order.find_by(id: order_item.order_id)
      order.order_inspection
      flash[:result_text] = "product #{order_item.product.name} has shipped!" 
      redirect_to fulfillment_path
      # render :template => "users/fulfillment", :locals => {:user => @user}
    else
      flash[:error] = "unable to ship #{order_item.product.name}"
      return head :not_found
    end
  end
  
  private
  def order_item_params
    params.require(:order_item).permit(:quantity)
  end
end
