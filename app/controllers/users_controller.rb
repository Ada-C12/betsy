class UsersController < ApplicationController
  skip_before_action :require_login, except: [:dashboard]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      head :not_found
      return
    end
  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      flash[:status] = :success
      flash[:result_text] = "Logged in as returning user #{user.name}"
    else
      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as new user #{user.name}"
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end
    
    session[:user_id] = user.id
    return redirect_to root_path
  end
  
  def destroy
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out!"
    
    redirect_to root_path
  end
  
  def dashboard
    @user = User.find_by(id: session[:user_id])
  end
  
  private
  
  # def user_params
  #   return params.require(:user).permit(:name, :email)
  # end
  
end
