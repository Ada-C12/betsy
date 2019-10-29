class OrdersController < ApplicationController
  def cart
    @order = Order.find_by(id: session[:order_id])
  end

  def checkout
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      flash[:error] = "Cannot checkout: Order no longer exists."
      return redirect_to root_path
    end
  end

  def update
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      return head :not_found
    end
    @order.status = "paid"

    if @order.update(order_params)
      @order.order_items.each do |order_item|
        updated_stock = order_item.updated_stock
        if updated_stock < 0
          flash[:error] = "There are not enough #{order_item.product.name}s in stock"
          return redirect_to cart_path
        end
        order_item.product.update_attributes(stock: updated_stock)
      end
      flash[:success] = "Successfully checked out"
      session[:order_id] = nil
      return redirect_to root_path
    else
      flash.now[:error] = "Could not checkout"
      render :checkout
      @order.update_attributes(status: "pending")
      return
    end
  end

  private

  def order_params
    params.require(:order).permit(:email, :owling_address, :name_on_cc, :name, :cc_num, :cc_exp_mo, :cc_exp_yr, :cc_cvv, :zip_code)
  end
end
