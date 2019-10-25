class OrdersController < ApplicationController
  
  before_action :find_order
  
  def index
    @orders = Order.all
  end
  
  # placeholder method
  def show; end
  
  def new
    @order = Order.new
  end
  
  def create
    @order = Order.new( order_params )
    @order.status = :pending
    if @order.save
      @order.order_items << OrderItem.create(product_id: params[product.id], order_id: @order.id)
      session[:order_id] = @order.id
      flash[:success] = "Successfully created order"
      redirect_to order_path(@order.id)
    else
      flash[:error] = "Could not create order"
      redirect_to root_path
    end
  end
  
  # placeholder method
  def edit; end
  
  def update
    if @order.update( order_params )
      if @order.order_items.length == 0
        # sets session to nil if there are no products in the order
        session[:order_id] = nil
        flash[:success] = "Order cancelled: all items removed from cart"
        redirect_to orders_path
      else
        # successfully updates order
        @order.order_items.update(qty: params[:order][:quantity])
        flash[:success] = "Successfully updated order"
        redirect_to order_path(@order.id)
      end
    else
      flash[:error] = "Could not update order"
      redirect_to orders_path
    end
  end
  
  def view_cart
    # this is for the view_cart_path
    # possibly make this the same as edit? -kk
  end
  
  def checkout
    # ideally the params will include all the info the customer entered into the checkout form
    @customer_info = params
  end
  
  def purchase
    @customer_info = params
    if @customer_info.valid?
      @order.status = :paid
      session[:order_id] = nil
      flash[:success] = "Successfully placed order!"
      redirect_to order_path(@order.id)
    else
      flash[:error] = "Could not place order"
      redirect_to order_path(@order.id)
    end
  end
  
  private
  
  def find_order
    @order = Order.find_by(id: params[:id])
  end
  
  def order_params
    # not sure whether it will return an order item or a product in the params
    return params.require(:order).permit(order_items: [])
  end
  
end
