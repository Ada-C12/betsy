class ProductsController < ApplicationController

    def show 
        @product = Product.find_by(id: params[:id])
        if @product.nil?
            head :not_found 
            return 
        end 
    end 
    

end
