class ApplicationController < ActionController::Base
  before_action :require_login 
  before_action :find_order

  def current_user 
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end 

  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in to do that."
      redirect_to root_path
    end 
  end

  def find_order
    @order = Order.find_by(id: params[:id]])
  end
  
end 
