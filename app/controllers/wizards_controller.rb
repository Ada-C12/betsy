class WizardsController < ApplicationController
  def show
    # @wizard = Wizard.find_by(id: session[:wizard_id])
    @wizard = Wizard.find_by(id: params[:id])
    
    @orders = @wizard.orders
    
    if params[:status]
      @orders = @wizard.orders.select { |order| order.status == params[:status] }
    end
  end
end
