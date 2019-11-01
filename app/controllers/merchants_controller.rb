class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :edit, :fulfillment] #, :update, :destroy]
  before_action :missing_merchant, only: [:show, :edit]
  
  def index
    @all_merchants = Merchant.all
  end
  
  def show
    @ordered_products = @merchant.fulfillments
  end
  
  def create
    if session[:merchant_id]
      flash[:warning] = "A merchant is already logged in."
      redirect_back(fallback_location: root_path)
    else
      auth_hash = request.env["omniauth.auth"]
      
      merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
      if merchant
        flash[:success] = "Logged in as returning merchant #{merchant.username}"
      else
        merchant = Merchant.build_from_github(auth_hash)
        if merchant.save
          flash[:success] = "Logged in as new merchant #{merchant.username}"
        else
          flash[:warning] = "Could not create new merchant account: #{merchant.errors.messages}"
          return redirect_to root_path
        end
      end
      
      session[:merchant_id] = merchant.id
      return redirect_to root_path
    end
  end
  
  def destroy
    if session[:merchant_id] == nil
      flash[:warning] = "You cannot log out because you are not logged in."
    else
      session[:merchant_id] = nil
      flash[:success] = "Successfully logged out!"
    end
    
    redirect_to root_path
  end
  
  private
  
  def merchant_params
    return params.require(:merchant).permit(:username, :email, :provider, :uid)
  end
  
  def find_merchant
    @merchant = Merchant.find_by_id(params[:id])
  end
  
  def missing_merchant
    if @merchant.nil?
      head :not_found
      return
    end
  end
end
