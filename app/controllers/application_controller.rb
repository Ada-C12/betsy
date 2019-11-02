class ApplicationController < ActionController::Base

  private

  def product
    product = Product.find_by(id: params[:id])
  end

  def wizard
    wizard = Wizard.find_by(id: params[:wizard_id])
    if product
      wizard = Wizard.find_by(id: product.wizard_id)
    end
    return wizard
  end

  def determine_wizard
    if wizard.nil?
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found    
    elsif session[:wizard_id].nil?
      flash[:error] = "You cannot complete action unless you are logged in"
      return redirect_to root_path
    elsif wizard.id != session[:wizard_id]
      flash[:error] = "You cannot complete action for a different Wizard's shop"
      return redirect_to root_path
    end
  end
end
