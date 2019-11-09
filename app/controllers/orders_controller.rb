class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end 

  def show

  end

  def create
    @order = Order.new(order_params)
    if @order.save
      # session can't be accessed in the model, which is why it is living here in the controller. 
      @order.placed_time = Time.now
      @order.save


      @order.status = "paid"
      @order.save
      
      

      session[:shopping_cart].each do |product_ids, quantity|
        
        order_item = OrderItem.create(quantity: quantity, product_id: product_ids, order_id: @order.id)
    
        
        product = Product.find_by(id: product_ids)
        product.quantity -= quantity 
        
      end 

      session[:shopping_cart].clear
      redirect_to confirmation_page_path(@order.id)
      
      return
    else
      @order.errors.each do |column, message|
        flash.now[:failure] = "Could not create new order. #{column.capitalize} #{message}"
      end
      render :new 
      return 
    end
  end 

  def new
    @order = Order.new
  end 

  def shopping_cart
    
    if session[:shopping_cart] != {}
      @product_ids = session[:shopping_cart].keys
    elsif
      @product_ids == nil
    end 
  end 

  def confirmation_page
    @order = Order.find_by(id: params[:id])
    
    
  end

  def remove_product_from_cart
    product = Product.find_by(id: params[:id])
    session[:shopping_cart].delete(product.id.to_s)

    if session[:shopping_cart] != {}
      @product_ids = session[:shopping_cart].keys
      
    elsif
      @product_ids == nil
    end 

    render :shopping_cart
    return
  end 

  # def change_quantity_of_cart
    
  # end 

  private

  def order_params
    params.require(:order).permit(:name, :address, :email, :credit_card_num, :cvv, :zip, :expiration_date, :status)
  end
end
