class OrderItemsController < ApplicationController

  # private
  
  # def product_params
  #   params.require(:product).permit(:name, :price, :quantity, :merchant_id, :description, :photo_url, :status, category_ids: [])
  # end
  def create
    if session[:order_id] && Order.find_by(id: session[:order_id]).status == 'complete'
      
      
    end

  end

end
