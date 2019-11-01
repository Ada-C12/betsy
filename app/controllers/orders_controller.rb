class OrdersController < ApplicationController
  
  before_action :find_user, only:[:complete_purchase, :purchase_confirmation]
  before_action :find_cart, only:[:complete_purchase, :purchase_confirmation, :add]

  def show
    #assert logged in
    @order = Order.find_by(id: params[:id])
    @user = @order&.user
  end
  
  def complete_purchase
    if @cart.order_items.count == 0
      flash[:status] = :failure
      flash[:result_text] = "Must have an item in cart to complete purchase"
      redirect_to cart_path
      return
    end
    
    if @cart.status = "pending"
      verification = User.verify_user_at_purchase(@cart.user)
      if verification != nil
        #there are validation errors from the user model
        flash[:status] = :failure
        flash[:messages] = verification
        redirect_to edit_user_path(@cart.user.id)
        return
      end
    end
    
    purchase_confirmation
  end
  
  def purchase_confirmation
    @cart.status = "paid"
    
    @cart.date_time_order_purchased = DateTime.now
    
    @cart.date_time_order_purchased
    @order_items = @cart.order_items
    
    @order_items.each do |order_item|
      product = order_item.product
      adjusting_quantity = order_item.quantity
      product.stock -= adjusting_quantity
      product.save
    end
    @cart.save
    
    new_cart = Order.create(user: @cart.user, status: "pending")
    session[:order_id] = new_cart.id
  end
  
  def cart
    @order = Order.find_by(id: get_cart[:order_id])
    session[:order_id] = @order.id
  end
  
  def add
    order_item = @cart.order_items.find {|oi| oi.product.id.to_s == product_id[:product_id]}
    if order_item
      order_item.quantity += order_item_params[:quantity].to_i
    else
      order_item = OrderItem.new(order_item_params.merge({order_id: @cart.id}).merge(product_id))
    end
    
    if order_item.save
      session[:order_id] = @cart.id
      flash[:status] = :success
      flash[:result_text] = "Added #{ order_item_params[:quantity] } #{ order_item.product.name } to cart"
    else
      flash[:status] = :failure
      flash[:error] = "unable to add to cart"
      flash[:messages] = order_item.errors.messages
      return redirect_to product_path(product_id[:product_id])
    end
    return redirect_to products_path
  end
  
  private
  
  
  def order_item_params
    params.require(:order_item).permit(:quantity).merge({ shipping_status: "pending" })
  end
  
  def product_id
    { product_id: params.require(:product_id) }
  end
end

