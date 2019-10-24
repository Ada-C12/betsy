class MerchantsController < ApplicationController
  before_action :require_login, except: [:index]

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      flash[:warning] = "Merchant with id #{params[:id]} was not found."
      redirect_to root_path
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
    merchant = Merchant.find_by(id: session[:merchant_id])

    if merchant.nil?
      head :not_found
      return
    end
  end

  def destroy
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end
  
end
