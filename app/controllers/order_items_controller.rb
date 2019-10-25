class OrderItemsController < ApplicationController

  def create
    product = Product.find_by(id: params[:product_id])
    if product.nil?
      return head :not_found 
    end


    # Order.create

    # @order_item = OrderItem.new(order_items_params).merge(shipped: false, product_id: product.id, order_id:)

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
