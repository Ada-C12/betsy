class WizardsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    wizard = Wizard.find_by(uid: auth_hash[:uid], provider: "github")
    # binding.pry
    if wizard
      flash[:success] = "Logged in as returning wizard #{wizard.username}"
    else
      wizard = Wizard.build_from_github(auth_hash)
      # binding.pry

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
