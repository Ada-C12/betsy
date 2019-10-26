class ReviewsController < ApplicationController
  #skip_before_action :require_login, :only => [:create, :show]
  skip_before_action :find_order
  
  def index
  end

  def show
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
