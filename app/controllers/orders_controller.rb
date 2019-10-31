class OrdersController < ApplicationController
  skip_before_action :require_login, only: [:cart, :checkout, :update_paid, :confirmation]
  skip_before_action :find_order, only: [:show, :update_paid, :cancel_order, :complete_order]
  before_action :find_order_params, only: [:show, :update_paid, :cancel_order, :complete_order]
  
  def show
    if !@order
      head :not_found 
      return 
    elsif !@order.contain_orderitems?(@current_user)
      flash[:error] = "You cannot check this order details!"
      return redirect_to root_path 
    end
  end
  
  def cart
  end
  
  def checkout
    if !@current_order
      head :not_found
      return
    elsif @current_order.order_items.empty?
      flash[:error] = "No item in the cart! Please add some items then checkout!"
      return redirect_to root_path
    end
  end
  
  def update_paid
    if !@order
      head :not_found 
      return 
    else
      @order.status = "paid"
      if @order.update(order_params)
        @order.order_items.each do |item|
          item.product.stock = item.product.update_quantity(item.quantity, @order.status)
          item.product.save
        end 
        flash[:success] = "Order #{@order.id} has been purchased successfully!"
        return redirect_to confirmation_path
        
      else
        flash[:error] = "Something went wrong! Order was not paid."
        flash[:errors] = @order.errors
        return redirect_to cart_path
      end
    end
  end
  
  def confirmation
    if @current_order && @current_order.status == 'paid'
      session[:cart_id] = nil
    else
      head :not_found 
      return 
    end
  end
  
  def cancel_order
    if !@order
      head :not_found 
      return 
    else
      if @order.contain_orderitems?(@current_user)
        if @order.update(status: "cancelled")
          @order.order_items.each do |item|
            item.product.stock = item.product.update_quantity(item.quantity, @order.status)
            item.product.save
          end
          flash[:success] = "Order #{@order.id} has been cancelled successfully!"
        else
          flash[:error] = "Something went wrong, order is not cancelled!"
        end
      else
        flash[:error] = "You're not allowed to cancel this order!"
      end
      return redirect_to current_user_path 
    end
  end
  
  def complete_order
    if !@order
      head :not_found 
      return 
    else
      if @order.contain_orderitems?(@current_user)
        if @order.update(status: "completed")
          flash[:success] = "Order #{@order.id} has been completed successfully!"
        else
          flash[:error] = "Something went wrong, order is not completed!"
        end
      else
        flash[:error] = "You're not allowed to complete this order!"
      end
      return redirect_to current_user_path 
    end
  end
  
  private
  
  def order_params
    return params.require(:order).permit(:name, :email, :address, :cc_name, :cc_last4, :cc_exp, :cc_cvv, :billing_zip, status: "paid")
  end
  
  def find_order_params
    @order = Order.find_by(id: params[:id])
  end
  
end

