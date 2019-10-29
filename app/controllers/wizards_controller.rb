class WizardsController < ApplicationController



def show 
    # @wizard = Wizard.find_by(id: session[:wizard_id])
    @wizard = Wizard.find_by(id: params[:id])
end 


end
