class ProductsController < ApplicationController
  # Can now be accessed via /, /books, or /authors/:author_id/books
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
        flash[:status] = :failure
        flash[:result_text] = "That Wizard does not exist"
        return redirect_to root_path
      end

    elsif category_id
      @category = Category.find_by(id: category_id)
      if @category
        @products = @category.products
      else
        flash[:status] = :failure
        flash[:result_text] = "That Category does not exist"
        return redirect_to root_path
      end
    end
  end
end
