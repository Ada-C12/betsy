class UsersController < ApplicationController
  skip_before_action :require_login, :only => [:create, :show]
  skip_before_action :find_order
  
  def show
    @user = User.find_by(id: params[:id])
    @products = @user.products.active
    if @user.nil?
      head :not_found
      return
    end
  end

  def current
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: params[:provider])
    if user 
      flash[:success] = "Logged in as user #{user.username}"
      #Since these are returning users, we could refer to them as their merchant name!
    else
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Welcome to Fruitsy, #{user.username}!"
      else
        flash[:error] = "Could not create user account #{user.errors.messages}"
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
      flash[:success] = "User data updated successfully."
      return redirect_to current_user_path
    else
      flash.now[:error] = "Could not update user account #{@current_user.errors.messages}"
      return render :edit
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path 
  end 

  private

  def user_params
    return params.require(:user).permit(:uid, :merchant_name, :email, :provider, :username)
  end
end
