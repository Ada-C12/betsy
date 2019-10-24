class ProductsController < ApplicationController
  def index
    wizard_id = params[:wizard_id]
    
    if wizard_id.nil?
      @products = Product.all
    else
      @wizard = Wizard.find_by(id: wizard_id)
      if @wizard
        @products = @wizard.products
      else
        head :not_found
      end
    end
  end
  
  
end
