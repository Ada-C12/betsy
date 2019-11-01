class OrderproductsController < ApplicationController
  before_action :find_orderproduct, only: [:show, :edit, :update, :destroy]
  before_action :if_orderproduct_missing, only: [:edit, :update, :destroy]
  # index and show ununsed so deleted

  def new
    @orderproduct = Orderproduct.new
  end

  def create
    # checks to see if product is in stock
    @product = Product.find_by(id: params[:product_id])
    if @product.stock < 1
      flash[:danger] = "Out of stock. Sorry!"
      redirect_to products_path
      return
    end
    # checks to see if there is an existing order going
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
      # if there isn't an existing order, creates one
    else
      @order = Order.create
      session[:order_id] = @order.id
    end
    # if there is already an order going and desired product is already in the cart, locates that orderproduct
    cur_orderproduct = Orderproduct.find_by(order_id: @order.id, product_id: @product.id)
    if cur_orderproduct != nil
      # if the max number of available stock for that product is already in the cart, buyer is unable to add another one to the order. we need this because items aren't deducted from stock until after checkout
      if cur_orderproduct.quantity == @product.stock
        flash[:danger] = "No more in stock. Sorry!"
        redirect_to products_path
        return
      else
        # if the max number hasn't been met, the item is added to the cart and the count of that product in this order goes up by one
        cur_orderproduct.quantity += 1
      end
      # if the order exists but that particular item isn't yet in the cart, the orderproduct is created with a quantity of 1
    else
      cur_orderproduct = Orderproduct.new(order_id: @order.id, product_id: @product.id, quantity: 1)
    end
    if cur_orderproduct.save
      flash[:success] = "Item added to cart."
      redirect_to order_path(@order.id)
      return
    else flash[:danger] = "Item NOT added to cart."
      render products_path
      return
    end
  end

  def edit ; end

  def update
    @orderproduct.update(orderproduct_params)
    redirect_to order_path(@orderproduct.order) # so that update is available again (goes from grey to black)
    return
  end

  def destroy
    if @orderproduct.destroy
      flash[:success] = "Item successfully deleted!"
      redirect_to order_path(@orderproduct.order)
    end
  end

  private
  def orderproduct_params
    return params.require(:orderproduct).permit(:order_id, :product_id, :quantity)
  end

  def find_orderproduct
    @orderproduct = Orderproduct.find_by(id: params[:id])
  end

  def if_orderproduct_missing
    if @orderproduct.nil?
      flash[:warning] = "Orderproduct with id #{params[:id]} was not found!"
      redirect_to order_path(:order_id)
      return
    end
  end
end
