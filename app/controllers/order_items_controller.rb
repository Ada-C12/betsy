class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order

  def create
    if @current_order
      order = @current_order
    else
      order = Order.create(status: "pending")
    end

    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end

    order_item = OrderItem.new(
      product: @product,
      order: order,
      quantity: order_item_params[:quantity]
    )

    if order_item.save
      flash[:success] = "Item successfully added to your basket."
      return redirect_back(fallback_location: :back)
    else
      raise
      flash[:error] = "Item could not be added to your basket."
      return redirect_back(fallback_location: :back)
    end
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
