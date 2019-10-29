class ApplicationController < ActionController::Base

  private

  def wizard
    wizard = Wizard.find_by(id: params[:wizard_id])
  end

  def determine_wizard
    if wizard.nil?
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found    
    elsif session[:wizard_id].nil?
      flash[:error] = "You must be logged in to create a new product"
      return redirect_to root_path
    elsif wizard.id != session[:wizard_id]
      flash[:error] = "You cannot create products for a different Wizard's shop"
      return redirect_to root_path
    end
  end
end
