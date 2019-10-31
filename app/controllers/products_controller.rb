class ProductsController < ApplicationController
  def homepage
    @products = Product.five_products
  end
  
  def index
    wizard_id = params[:wizard_id]
    category_id = params[:category_id]

    if wizard_id.nil? && category_id.nil?
      @products = Product.all

    elsif wizard_id
      @wizard = Wizard.find_by(id: wizard_id)
      if @wizard
        @products = @wizard.products
      else
        flash[:error] = "That Wizard does not exist"
        return redirect_to root_path
      end

    elsif category_id
      @category = Category.find_by(id: category_id)
      if @category
        @products = @category.products
      else
        flash[:error] = "That Category does not exist"
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

  def make_retired_true
    @product = Product.find_by(id: params[:id])

    @product.make_retired_true
    
    return redirect_back(fallback_location: :back)
  end

  def make_retired_false
    @product = Product.find_by(id: params[:id])

    @product.make_retired_false
    return redirect_back(fallback_location: :back)
  end
end
