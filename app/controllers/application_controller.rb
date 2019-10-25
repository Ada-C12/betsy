class ApplicationController < ActionController::Base

  #before_action :require_login

  def current_merchant
    if session[:merchant_id]
      @current_merchant ||= Merchant.find_by(id: session[:merchant_id])
    end
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end
end
