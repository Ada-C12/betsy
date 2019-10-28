class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order

  def create
    if @current_order
      order = @current_order
    else
      order = Order.create
    end
    product = Product.find_by(id: params[:id])

    order_item = OrderItem.create(
      product: product,
      order: order,
      quantity: order_item_params
    )
    order.order_items << order_item
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  def order_item_params
    return params.require(:order_item).permit(:product, :order, :quantity)
  end
end
