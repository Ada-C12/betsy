class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order

  def create
    if @current_order
      order = @current_order
    else
      order = Order.create(status: "pending")
      session[:cart_id] = order.id
    end

    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end
    #add logic so cannot create order item if quantity exceeds stock
    if order.order_items.where(product: @product)
      order_item = order.order_items.where(product: @product).first
      quantity = order_item_params[:quantity].to_i + order_item.quantity
      order_item.update(quantity: quantity)
      flash[:success] = "Item successfully added to your basket."
      return redirect_back(fallback_location: :back)
    else
      order_item = OrderItem.new(
        product: @product,
        order: order,
        quantity: order_item_params[:quantity]
      )
    end

    if order_item.save
      flash[:success] = "Item successfully added to your basket."
      return redirect_back(fallback_location: :back)
    else
      raise
      flash[:error] = "Item could not be added to your basket."
      return redirect_back(fallback_location: :back)
    end
  end

  def update
    order_item = OrderItem.find_by(id: params[:id])

    if order_item.update(order_item_params)
      flash[:success] = "Item successfully updated."
    else
      flash[:error] = "Could not update item quantity."
    end
    return redirect_to cart_path
  end

  def destroy
    order_item = OrderItem.find_by(id: params[:id])
    if order_item.nil?
      return redirect_to cart_path
    else
      if order_item.destroy
        flash[:success] = "Item successfully removed from your basket."
      else
        flash.now[:error] = "A problem occurred."
      end
    return redirect_to cart_path
    end
  end
  
  def order_item_params
    return params.require(:order_item).permit(:product, :order, :quantity)
  end
end
