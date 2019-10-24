class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:edit, :update, :destroy]
  
  def create
    @orderitem = Orderitem.new(
      quantity: params[:orderitem][:quantity],
      product_id: params[:id],
      order_id: session[:order_id]
    )
    
    if @orderitem.save
      flash[:status] = :success
      flash[:result_text] = "#{@orderitem.product.name} has been added to the cart"  
    else 
      flash[:status] = :failure
      flash[:result_text] = "Could not add #{@orderitem.product.name} to cart"
      flash[:messages] = @orderitem.errors.messages
    end
    
    redirect_back fallback_location: root_path
    return
  end
  
  def edit ; end
  
  def update
    if @orderitem.update(quantity: params[:orderitem][:quantity])
      flash[:status] = :success
      flash[:result_text] = "Quantity has been updated"
      # TIFFANY YOU NEED TO REDIRECT TO THE CART PAGE
      # IS CURRENTLY NOT CREATED
      redirect_to root_path 
      return
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update #{@orderitem.product.name}"
      flash.now[:messages] = @orderitem.errors.messages
      render :edit
      return
    end
  end
  
  def destroy
    @orderitem.edstroy
    flash[:status] = :success
    flash[:result_text] = "#{@orderitem.product.name} removed"
    # TIFFANY YOU NEED TO REDIRECT TO THE CART PAGE
    # IS CURRENTLY NOT CREATED
    redirect_to root_path
  end
  
  private
  
  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id])
    render_404 unless @orderitem
  end
end
