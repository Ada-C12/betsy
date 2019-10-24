class UsersController < ApplicationController

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      head :not_found
      return
    end
  end

  def current
    @user = User.find_by(id: session[:user_id])
    if @user.nil?
      head :not_found
      return
    end
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
    @user = User.find_by(id: session[:user_id])
    if @user.nil?
      flash[:error] = "You must be logged in to do that."
      redirect_to root_path
    end
  end

  def update
    @user = User.find_by(id: session[:user_id])
    if @user.nil?
      flash[:error] = "You must be logged in to do that."
      return redirect_to root_path
    else
      if @user.update(user_params)
        flash[:success] = "User data updated successfully."
        return redirect_to current_user_path
      else
        flash.now[:error] = "Could not update user account #{@user.errors.messages}"
        return render :edit
      end
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
