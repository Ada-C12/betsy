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

    if order.order_items.where(product: @product).length > 0
      order_item = order.order_items.where(product: @product).first
      order_item.increase_quantity(order_item_params[:quantity].to_i)
      flash[:success] = "Item successfully added to your basket."
      return redirect_back(fallback_location: cart_path)
    else
      order_item = OrderItem.new(
        product: @product,
        order: order,
        quantity: order_item_params[:quantity]
      )
    end

    if order_item.save
      flash[:success] = "Item successfully added to your basket."
      return redirect_back(fallback_location: cart_path)
    else
      flash[:error] = "Item could not be added to your basket."
      return redirect_back(fallback_location: :root)
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

  private
  
  def order_item_params
    return params.require(:order_item).permit(:product, :order, :quantity)
  end
end
