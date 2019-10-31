class OrderItemsController < ApplicationController
  skip_before_action :require_login
  before_action :find_order

  def create
    if @current_order.nil?
      @current_order = Order.new_order
      session[:cart_id] = @current_order.id
    end
  
    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end
    
    if !@product.quantity_available?(order_item_params[:quantity].to_i)
      flash[:error] = "Quantity entered is greater than available stock for #{@product.name}."
      return redirect_back(fallback_location: cart_path)
    elsif !@current_order.order_items.where(product: @product).empty?
      order_item = @current_order.order_items.find_by(product: @product)
      order_item.increase_quantity(order_item_params[:quantity].to_i)
      flash[:success] = "#{@product.name} successfully added to your basket!"
      return redirect_back(fallback_location: cart_path)
    else
      order_item = OrderItem.new(
        product: @product,
        order: @current_order,
        quantity: order_item_params[:quantity]
      )
    end

    if order_item.save
      flash[:success] = "#{@product.name} successfully added to your basket!"
      return redirect_back(fallback_location: cart_path)
    else
      flash[:error] = "#{@product.name} was not added to your basket."
      flash[:errors] = order_item.errors.messages
      return redirect_back(fallback_location: :root)
    end
  end

  def update
    order_item = OrderItem.find_by(id: params[:id])
    product = order_item.product

    if product.quantity_available?(order_item_params[:quantity].to_i)
      if order_item.update(order_item_params)
        flash[:success] = "#{product.name} successfully updated!"
      else
        flash[:error] = "Could not update quantity for #{product.name}."
        flash[:errors] = order_item.errors.messages
      end
    else
      flash[:error] = "Quantity entered is greater than available stock for #{product.name}."
    end
    return redirect_to cart_path
  end

  def destroy
    order_item = OrderItem.find_by(id: params[:id])
    if order_item
      if order_item.destroy
        flash[:success] = "#{@product.name} successfully removed from your basket!"
      else
        flash.now[:error] = "A problem occurred. #{@product.name} was not successfully removed from your basket."
      end
    end
    return redirect_to cart_path
  end

  private
  
  def order_item_params
    return params.require(:order_item).permit(:product, :order, :quantity)
  end
end
