class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception
  
  before_action :find_user
  
  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new("Not Found")
  end
  
  private
  
  def find_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
    return @login_user
  end
  
  def find_cart
    @cart = Order.find_by(id: get_cart[:order_id])
  end
  
  def get_cart
    id = session[:order_id]
    
    if id
      return { order_id: id }
    else
      user = User.create
      return { order_id: Order.create(user: user, status: "pending").id }
    end
  end
end
