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
        flash[:error] = "That Wizard does not exist"
        return redirect_to root_path
      end
    end
  end
  
end
