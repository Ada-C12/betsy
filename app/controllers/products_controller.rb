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
        flash[:status] = :success
        flash[:result_text] = "That Wizard does not exist"
        return redirect_to root_path
      end
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    end
  end
end
