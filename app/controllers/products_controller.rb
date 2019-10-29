class ProductsController < ApplicationController

  before_action :determine_wizard, only: [:new, :create]

  def homepage
    @products = Product.five_products
  end

  def new
    @product = Product.new(wizard_id: params[:wizard_id])
  end

  def create
    @product = Product.new(product_params)
    @product.wizard = Wizard.find_by(id: wizard.id)
    
    if @product.save
      flash[:success] = "Successfully Added #{@product.name}"
      redirect_to wizard_path(wizard.id)
      return 
    else
      flash[:error] = "Could not add product to shop"
      render :new, status: :bad_request
      return 
    end
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
end

private

def product_params
  product_params = params.require(:product).permit(:name, :description, :stock, :photo_url, :price, :category_ids => [])
  product_params[:category_ids].reject!(&:blank?)
  return product_params
end
