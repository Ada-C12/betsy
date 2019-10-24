class UsersController < ApplicationController

  def show
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
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path 
  end 


end
