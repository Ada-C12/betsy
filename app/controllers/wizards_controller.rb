class WizardsController < ApplicationController
  def show
    # @wizard = Wizard.find_by(id: session[:wizard_id])
    @wizard = Wizard.find_by(id: params[:id])
    
    @orders = @wizard.orders
    
    if params[:status]
      @orders = @wizard.orders.select { |order| order.status == params[:status] }
    end
  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    wizard = Wizard.find_by(uid: auth_hash[:uid], provider: "github")
    if wizard
      flash[:success] = "Logged in as returning wizard #{wizard.username}"
    else
      wizard = Wizard.build_from_github(auth_hash)
      
      if wizard.save
        flash[:success] = "Logged in as new wizard #{wizard.username}"
      else
        flash[:error] = "Could not create new wizard account: #{wizard.errors.messages}"
        return redirect_to root_path
      end
    end
    session[:wizard_id] = wizard.id
    redirect_to root_path
  end
  
  
  def destroy
    session[:wizard_id] = nil
    flash[:success] = "Successfully logged out!"
    
    redirect_to root_path
  end
end
