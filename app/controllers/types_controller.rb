class TypesController < ApplicationController

  def show
    @type = Type.find_by(id: params[:id])
    if @type.nil?
      flash[:status] = :failure
      flash[:result_text] = "This category does not exist."
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
    else 
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@type.name}."
      flash[:messages] = @type.errors.messages
    end
    
    redirect_back fallback_location: root_path
    return
  end
  
end
