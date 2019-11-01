class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update, :destroy]
  before_action :if_order_missing, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
  end

  def show ; end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    orderproduct = Orderproduct.new(order_id: @order.id, product_id: params[:product][:id], quantity: 1)
  end

  def edit ; end

  def update
    if @order.update(order_params)
      @order.orderproducts.each do |orderproduct|
        product = orderproduct.product
        product.stock -= orderproduct.quantity
        product.save
      end
      session[:order_id] = nil
      flash[:success] = "Order placed!"
      redirect_to confirmation_path(@order)
      return
    else
      flash.now[:danger] = "Order failed!"
      render :edit
      return
    end
  end

  # deleted destroy because not used
  
  private
  def order_params
    return params.require(:order).permit(:status, :name, :email, :mailing_address, :zip, :name_on_cc, :cc_number, :cc_cvc, :cc_exp, :quantity, product_ids: [])
  end

  def find_order
    @order = Order.find_by(id: params[:id])
  end

  def if_order_missing
    if @order.nil?
      flash[:warning] = "Order with id #{params[:id]} was not found!"
      redirect_to products_path
      return
    end
  end
end
