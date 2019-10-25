class MerchantsController < ApplicationController
  before_action :require_login, except: [:index, :destroy, :create]
 

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: session[:merchant_id])
    if @merchant.nil?
      flash[:warning] = "Merchant with id #{params[:id]} was not found."
      redirect_to root_path
    
    
    # p '==================='
    # p params[:id]
    # p session[merchant_id]
    # elsif params[:id] != session[:merchant_id]
    #   redirect_to root_path
    #   flash[:error] = "You are not authorized to view this page."
    end

    
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")

    if merchant
      flash[:success] = "Logged in as returning merchant #{merchant.username}."
    else
      merchant = Merchant.build_from_github(auth_hash)
     
      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}."
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end 
    end

    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def current
    @current_merchant = Merchant.find_by(id: session[:merchant_id])

    unless @current_merchant
      flash[:error] = "You must be a logged in authorized merchant to access this page"
      redirect_to root_path
    end
  end

  def destroy
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end
  
end
