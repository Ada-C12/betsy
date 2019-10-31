class UsersController < ApplicationController
  skip_before_action :require_login, :only => [:create, :show]
  skip_before_action :find_order
  
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      head :not_found
      return
    end
    @products = @user.products.active
  end
  
  def current
    if params[:status].nil?
      @order_items = @current_user.find_order_items
    else
      @order_items = @current_user.filter_order_items(params[:status])
    end
  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: params[:provider])
    if user 
      if user.merchant_name
        flash[:success] = "Welcome back #{user.merchant_name}! Manage your fruitstand or browse Fruitsy! "
      else
        flash[:success] = "Welcome back #{user.username}! Enjoy browsing Fruitsy."
      end
    else
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Welcome to Fruitsy, #{user.username}!"
      else
        flash[:error] = "Oops, something happened! Could not create user account, please try again."
        return redirect_to root_path 
      end 
    end
    session[:user_id] = user.id 
    redirect_to root_path
  end
  
  def edit
  end
  
  def update
    if @current_user.update(user_params)
      flash[:success] = "#{@current_user.username} updated successfully!"
      return redirect_to current_user_path
    else
      flash.now[:error] = "Please provide all required fields to edit your account."
      return render :edit
    end
  end
  
  def destroy
    username = @current_user.username
    session[:user_id] = nil
    flash[:success] = "You are successfully logged out, #{username}!"
    redirect_to root_path 
  end 
  
  private
  
  def user_params
    return params.require(:user).permit(:uid, :merchant_name, :email, :provider, :username)
  end

end
