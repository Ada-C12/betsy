class ApplicationController < ActionController::Base
  before_action :set_cart
  protect_from_forgery with: :exception
 
  private
 
  # def set_cart
  #   @cart = Order.find_by(id: session[:order_id])
  #   if @cart.nil?
  #     @cart = Order.new
  #     # empty cart. Not sure if I like this. 
  #     session[:order_id] = @cart.id
  #   end 
  # end 

  def set_cart
    session[:shopping_cart] ||= {}
    # if session[:shopping_cart] is true/has something in it, then keep what is in it. Otherwise, set it
    # to an empty hash. 
  end 
  # before_action :find_merchant

  before_action :find_merchant

  def current_merchant
    @current_merchant ||= Merchant.find(session[:user_id]) if session[:user_id]
  end

  def find_merchant
    if current_merchant.nil?
      flash[:status] = :error
      flash[:result_text] = "You must log in to access this page"
      return redirect_to root_path
    end
  end
end