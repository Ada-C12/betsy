class UsersController < ApplicationController
  before_action :find_cart, only: [:edit, :update]
  before_action :find_user, only: [:fulfillment]
  
  def index
    @users = User.all
    @categories = Category.all
    @products = Product.all
  end
  
  def dashboard
    is_authenticated?
    user_id = session[:user_id]
    item = params[:item] || 'products'
    
    if item == 'products'
      @products = Product.where(user_id: user_id) # change to user_id
    else 
      @categories = Category.all
    end
  end

  def fulfillment
    @user = find_user
    @orders = @user.my_orders(params[:status])
  end
  
  def fulfillment
    @user = find_user
  end
  
  def show
    is_authenticated?
    @user = User.find_by(id: params[:id])
    
    render_404 unless @user
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = @cart.user
  end
  
  def update
    user = @cart.user
    
    if user.update(user_params)
      flash[:status] = :success
      flash[:result_text] = "successfully updated payment information"
      redirect_to complete_purchase_path(@cart.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "missing or invalid payment information"
      redirect_to edit_user_path(@cart.user)
    end
  end
  
  def current
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:message] = "You have logged out successfully."
    redirect_to root_path
  end
  
  def find_user
    @current_user = User.find_by(id: session[:user_id])
  end
  
  def index
    @users = User.all
    @categories = Category.all
    @products = Product.all
  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      # User was found in the database
      flash[:status] = :success
      flash[:result_text] = "Logged in as returning user #{user.username}"
    else
      # User doesn't match anything in the DB
      # Attempt to create a new user
      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as new user #{user.username}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:status] = :failure
        flash[:result_text] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end
    
    # If we get here, we have a valid user instance
    session[:user_id] = user.id
    return redirect_to root_path
  end
  
  def destroy
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out!"
    
    redirect_to root_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :cc_name, :cc_number, :cc_expiration, :cvv, :billing_zip, :street_address, :city, :state, :mailing_zip)
  end
  
  def is_authenticated?
    is_logged_in = session[:user_id]
    if is_logged_in.nil?
      flash[:status] = :failure
      flash[:result_text] = "Can't access"
      
      redirect_to root_path
      return
    end
  end
end
