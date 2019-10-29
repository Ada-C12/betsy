class ApplicationController < ActionController::Base

 

  def current_merchant
    if session[:merchant_id]
      @current_merchant ||= Merchant.find_by(id: session[:merchant_id])
    end
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in as an authorized merchant to access this page."
      return redirect_to root_path
    end
  end
end
