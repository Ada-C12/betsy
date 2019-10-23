class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    #this is a show comment
  end
  
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end 
end
