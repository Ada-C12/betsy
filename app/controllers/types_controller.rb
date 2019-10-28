class TypesController < ApplicationController

  before_action :require_login, except: [:show]

  def show
    @type = Type.find_by(id: params[:id])
    if @type.nil?
      flash[:status] = :failure
      flash[:result_text] = "This category does not exist."
      redirect_to root_path
      return
    end
  end

  def new
    @type = Type.new
  end

  def create
    @type = Type.create(name: params[:type][:name])

    if @type.save
      flash[:status] = :success
      flash[:result_text] = "#{@type.name} has been created."  
      redirect_to root_path
      return
    else 
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@type.name}."
      flash[:messages] = @type.errors.messages
      render :new, status: :bad_request
    end
  end
  
end
