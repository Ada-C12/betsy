class MerchantsController < ApplicationController
  before_action :find_merchant, except: [:index, :create]

  def index
    @merchants = Merchant.all
  end

  def show
    current_merchant
    if @current_merchant.id.to_s == params[:id]
      @merchant = Merchant.find_by(id: params[:id])
    else
      flash[:status] = :error
      flash[:result_text] = "You have no authorization access to this page"
      return redirect_to root_path
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(UID: auth_hash[:uid], provider: "github")
    if merchant
      flash[:status] = :success
      flash[:result_text] = "Logged in as returning merchant #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)
      if merchant.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as new merchant #{merchant.username}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = merchant.id
    return redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out!"

    redirect_to root_path
  end
end
