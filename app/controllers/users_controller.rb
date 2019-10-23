class UsersController < ApplicationController
  
  def create
    auth_hash = request.env["omniauth.auth"]
    
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    
    if user
      flash[:success] = "Successfully logged in as returning user #{user.username}"
    else
      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:success] = "Successfully logged in as new user #{user.username}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        # redirect_to root_path
        return
      end
    end
    
    session[:user_id] = user.id
    # redirect_to root_path
    return
  end
  
end
