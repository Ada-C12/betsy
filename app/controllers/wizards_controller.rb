class WizardsController < ApplicationController

  def products
    @wizard = Wizard.find_by(id: params[:id])

    if @wizard.nil?
      flash[:status] = :success
      flash[:result_text] = "That Wizard does not exist"
      return redirect_to root_path
    end
  end
end
