class ProductsController < ApplicationController

  # Can now be accessed via /, /books, or /authors/:author_id/books
  def index
    category_id = params[:category_id]
    if category_id.nil?
      @products = Product.all
    else 
      @category = Category.find_by(id: category_id)
      if @category
        @products = @category.products
      else
        render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
        return
      end
    end
  end
end
