class OrderItemsController < ApplicationController
  before_action :find_order, only: [:create, :update, :mark_shipped]
  before_action :find_order_item, only: [:update, :mark_shipped]
  
  def create
    if @order.nil?
      @order = Order.create
      session[:order_id] = @order.id
    end
    
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      flash[:error] = "Product doesn't exist!"
      redirect_to products_path
      return
    elsif !@product.in_stock? || @product.status == "retired"
      flash[:error] = "#{@product.name} is not available!"
    else
      @order_item = @order.find_order_item_by_product_id(@product.id)
      
      if @order_item
        if @order_item.quantity < @product.stock
          @order_item.quantity += 1
          flash[:success] = "Item was successfully added to cart!"
        else
          flash[:error] = "Not enough stock to add more to your cart!"
        end
      else
        @order_item = OrderItem.new(
          product_id: params[:id],
          order_id: session[:order_id],
          quantity: 1,
        )
        flash[:success] = "Item was successfully added to cart!"
      end
      
      if !@order_item.save
        flash[:error] = "Failed to add item to cart!"
      end
    end
    
    redirect_to product_path(@product.id)
    return
  end
  
  def update
    if @order.nil?
      redirect_to products_path
      return
    end
    
    if @order_item && @order_item.order_id == @order.id
      quantity_difference = @order_item.quantity_change(@order_item.order, params[:order_item][:quantity])
      @product = @order_item.product
      
      if @product.update_stock(quantity_difference)
        @order_item.quantity = params[:order_item][:quantity]
        
        if @order_item.save
          flash[:success] = "Item in cart was successfully updated"
        else
          flash[:error] = "Failed to update item in cart!"
        end
      else
        flash[:error] = "There aren't enough items in stock for your order!"
      end
    end
    
    redirect_to order_path(@order.id)
    return
  end
  
  def destroy
    order_item = OrderItem.find_by(id: params[:id])
    if order_item
      order_item.destroy
      flash[:success] = "Item: " + order_item.product.name + " was successfully deleted!"
    end
    
    redirect_to order_path
    return
  end
  
  def mark_shipped
    @order_item.toggle_shipped
    if @order_item.save && @order.order_items.all? {|item| item.status == "shipped"}
      @order.change_status("complete")
      @order.save
    end
  end
  
  private
  
  def find_order
    @order = Order.find_by(id: session[:order_id])
  end
  
  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end
end
