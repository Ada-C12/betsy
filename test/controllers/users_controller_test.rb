require "test_helper"

describe UsersController do
  
  describe "index action" do
    it "gives back a successful response" do
      get users_path

      must_respond_with :success
    end
  end

  describe 'show action' do
    it 'responds with a success when id given exists' do

      get user_path(users(:valid_user).id)

      must_respond_with :success

    end

    it 'responds with a not_found when id given does not exist' do

      get user_path("-500")

      must_respond_with :not_found
    end
  end
  
  describe "create" do
    it "logs in an existing user and redirects them to the root path" do
      user = users(:valid_user)
      expect {
        perform_login(user)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      # You can test the flash notice too!
    end

    it "logs in a new user and redirects them back to the root path" do
      user = User.new(name: "Batman", provider: "github", uid: 999, email: "bat@man.com")
      OmniAuth.config.mock_auth[:github] = 
        OmniAuth::AuthHash.new(mock_auth_hash(user))

        expect {
          get auth_callback_path(:github)
        }.must_differ "User.count", 1

        user = User.find_by(uid: user.uid)
  
        must_redirect_to root_path
        expect(session[:user_id]).must_equal user.id
        # You can test the flash notice too!
    end

    it "should redirect back to root for invalid callbacks" do
      OmniAuth.config.mock_auth[:github] = 
      OmniAuth::AuthHash.new(mock_auth_hash(User.new))
      
      expect {
        get auth_callback_path(:github)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
    end
  end

  describe "destroy" do
    it "ends the session when the user clicks logout" do
      delete logout_path
      must_redirect_to root_path
    end
  end
end
