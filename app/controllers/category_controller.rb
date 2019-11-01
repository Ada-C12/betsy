class CategoryController < ApplicationController
    before_action :find_category, only: [:show]
    before_action :missing_category, only: [:show]

    def index 
        @category = Category.all.order(:id)
    end

    def new
        @category = Category.new    
    end

    def create 
        @category = Category.new(category_param)
        if @category.save
            flash[:status] = :success
            flash[:result_text] = "Successfully added a new category"

            redirect_to dashboard_path(item: 'categories')
        else
            flash[:status] = :failure
            flash[:result_text] = "Failed to add a new category"
            render new_category_path
           
        end
    end

    def show
    end
    
    def edit
        @category = Category.find_by(id: params[:id])
        
        if @category.nil?
          head :not_found
        end
    end

    def update
        @category = Category.find_by(id: params[:id])
        
        if @category.nil?
          head :not_found
          return
        else
          @category.update(category_param)
          redirect_to dashboard_path(item: "categories")
        end
    end 
    

    private

    def category_param
        return params.require(:category).permit(:label)
    end


    def find_category
        @category = Category.find_by_id(params[:id])
    end

    def missing_category
        if @category.nil?
            flash[:error] = "Could not find the category with the id #{params[:id]}."
            
            redirect_to root_path
        end
    end
end
