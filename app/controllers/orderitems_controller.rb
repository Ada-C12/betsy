class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:edit, :update, :destroy, :mark_shipped]
  
  def create
    # When adding items to an Order, does an order_id exist in sessions?
    # If yes, add to existing Order
    # Else, create a new Order
    if session[:order_id] && Order.find_by(id: session[:order_id])
      @order = Order.find_by(id: session[:order_id])
    else
      @order = Order.new(status: "pending")
      
      unless @order.save
        flash[:status] = :failure
        flash[:result_text] = "Something went wrong. Please refresh and try again."
        flash[:messages] = @order.errors.messages
      end
      
      session[:order_id] = @order.id
    end
    
    # Does an existing order already contain your product?
    # If yes, increase the quantity of that specific product
    # Else, create a new product
    @orderitem = Orderitem.find_by(order_id: session[:order_id], product_id: params[:product_id])
    
    if @orderitem
      @orderitem.quantity += params[:orderitem][:quantity].to_i
    else
      @orderitem = Orderitem.new(
        quantity: params[:orderitem][:quantity],
        product_id: params[:product_id],
        order_id: @order.id,
        shipped: false
      )
    end
    
    # Now save and see if validation fights you
    if @orderitem.save
      flash[:status] = :success
      flash[:result_text] = "#{@orderitem.product.name} has been added to your cart!"  
    else 
      flash[:status] = :failure
      flash[:result_text] = "Could not add the item to the cart."
      flash[:messages] = @orderitem.errors.messages
    end
    
    redirect_back fallback_location: root_path
    return
  end
  
  def edit ; end
  
  def update
    if @orderitem.order.status == "pending"
      if @orderitem.update(quantity: params[:orderitem][:quantity])
        flash[:status] = :success
        flash[:result_text] = "Quantity has been updated."
        
        redirect_to cart_path
        return
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not update item."
        flash.now[:messages] = @orderitem.errors.messages
        
        render :edit, status: :bad_request
        return
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot update items that are part of a #{@orderitem.order.status} order."
      redirect_to root_path
    end
  end
  
  def destroy
    if @orderitem.order.status == "pending"
      @orderitem.destroy
      
      flash[:status] = :success
      flash[:result_text] = "#{@orderitem.product.name} removed from cart."
      
      redirect_to cart_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot delete items that are part of a #{@orderitem.order.status} order."
      redirect_to root_path
    end
  end
  
  def mark_shipped
    if @orderitem.order.status == "paid" && @orderitem.shipped == false
      @orderitem.shipped = true
      @orderitem.save
      
      flash[:status] = :success
      flash[:result_text] = "#{@orderitem.product.name} has been marked as shipped."
      
      @orderitem.order.mark_as_complete?
      
      redirect_back fallback_location: root_path
    elsif @orderitem.order.status == "paid" && @orderitem.shipped == true
      flash[:status] = :failure
      flash[:result_text] = "#{@orderitem.shipped} has already been marked as shipped."
      
      redirect_back fallback_location: root_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot perform this action for a #{@orderitem.order.status} order."
      
      redirect_to root_path
    end
  end
  
  private
  
  
  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id])
    head :not_found unless @orderitem
  end
end
