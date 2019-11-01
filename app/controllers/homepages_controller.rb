class HomepagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :find_order
  
  def index
  end 
end
