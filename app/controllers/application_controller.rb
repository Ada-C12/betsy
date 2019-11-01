class ApplicationController < ActionController::Base

  before_action :current_order
  before_action :require_login

  def current_order
    if session[:order_id]
      @current_order = Order.find_by(id: session[:order_id])
    else
      @current_order = Order.create(status: "pending")
      session[:order_id] = @current_order.id
    end
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def require_login
    if current_user.nil?
      flash[:status] = :warning
      flash[:result_text] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end
      
end
