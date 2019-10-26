class ApplicationController < ActionController::Base
  before_action :require_login 

  def current_user 
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end 

  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in to do that."
      redirect_to root_path
    end 
  end

  def current_order
    @current_order ||= Order.find(session[:cart_id]) if session[:order_id]
  end
end 
