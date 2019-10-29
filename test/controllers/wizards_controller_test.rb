require "test_helper"
require 'pry'
describe WizardsController do



  describe "auth_callback" do
    it "logs in an existing wizard and redirects to the root route" do
      start_count = Wizard.count
      wizard = wizards(:wizard1)
      
      perform_login(wizard)
      
      must_redirect_to root_path
      expect(session[:wizard_id]).must_equal wizard.id
      Wizard.count.must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      new_wizard = Wizard.new(provider: "github", uid: 99999, username: "testing", email: "test@wizard.com")
# binding.pry
      expect{
      perform_login(new_wizard)
      }.must_differ "Wizard.count", 1

      must_redirect_to root_path
      expect(session[:wizard_id]).must_equal Wizard.last.id

    end
    
    it "redirects to the login route if given invalid user data" do
      Wizard.destroy_all

      expect{
        perform_login(Wizard.new)
      }.wont_change "Wizard.count"

      must_redirect_to root_path
      expect(session[:wizard_id].must_equal nil)
    end
  end

  describe "destroy action" do
    wizard = wizards(:wizard1)
    perform_login(wizard)

    expect{
      delete logout_path
    }

  end
end
