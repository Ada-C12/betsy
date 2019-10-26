class OrderItemsController < ApplicationController
  skip_before_action :require_login
  # skip find_order for some actions
  skip_before_action :find_order, only: []

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
