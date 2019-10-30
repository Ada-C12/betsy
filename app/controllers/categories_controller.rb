class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(category_params)
    wizard = Wizard.find_by(id: session[:wizard_id])
    if @category.save
      flash[:success] = "Successfully created #{@category.name} category"
      return redirect_to wizard_path(wizard.id)
    else
      flash.now[:error] = "A problem occurred: Could not create category"
      return render new_category_path, status: :bad_request
    end
  end
  
  private
  
  def category_params
    return params.require(:category).permit(:name)
  end
end
