require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects them to the root path" do
      user = users(:gretchen)
    
      expect{
        perform_login(user)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      assert_equal "Logged in as user #{user.username}", flash[:success]
    end

    it "logs in a new user and redirects them back to the root path" do
      user = User.new(
        uid: "465",
        email: "queen_mary@marysberries.com",
        provider: "github",
        username: "merryberry2"
      )

      expect {
        perform_login(user)
      }.must_differ "User.count", 1

      user = User.find_by(uid: user.uid)

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      assert_equal "Welcome to Fruitsy, #{user.username}!", flash[:success]
    end

    it "redirects back to the root path for invalid callbacks" do
      
      expect {
        perform_login(User.new)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
    end
  end

  describe "logged in user" do 
    before do
      perform_login
    end

    describe "current" do
      it "responds with success when a user has logged in" do
        get current_user_path

        must_respond_with :success
      end
    end 

    describe "show" do
      it "responds with success when a user id exists" do
        get user_path(users(:ada).id)

        must_respond_with :success
      end

      it "responds with a not_found when a users id does not exist" do
        get user_path(-1)

        must_respond_with :not_found
      end
    end

    describe "edit" do
      it "can get to the edit page if the user is logged in" do
        get edit_user_path
        
        must_respond_with :success
      end
    end

    describe "update" do
      it "updates an existing user successfully, if logged in, and redirects to current user path" do
        user = users(:gretchen)
        perform_login(user)

        updated_user_data = {
          user: {
            uid: user.uid,
            merchant_name: "Grapes?",
            email: user.email,
            provider: user.provider,
            username: user.username
          }
        }

        expect {
          patch current_user_path, params: updated_user_data
        }.wont_change "User.count"

        expect(User.find_by(id: user.id).merchant_name).must_equal updated_user_data[:user][:merchant_name]
        must_redirect_to current_user_path
        assert_equal "User data updated successfully.", flash[:success]
      end

      it "will not update an existing user if given invalid params" do
        user = users(:ada)
        perform_login(user)
        updated_user_data = {
          user: {
            uid: nil,
            merchant_name: "Grapes?",
            email: nil,
            provider: user.provider,
            username: nil
          }
        }

        expect {
          patch current_user_path, params: updated_user_data
        }.wont_change "User.count"

        expect(User.find_by(id: user.id).uid).wont_be_nil
        expect(User.find_by(id: user.id).email).wont_be_nil
        expect(User.find_by(id: user.id).username).wont_be_nil
        expect(flash[:error]).must_include "Could not update user account"
      end
    end

    describe "destroy" do
      it "successfully logs out a logged in user" do
        expect {
          delete logout_path
        }.wont_change "User.count"

        must_redirect_to root_path
        expect(session[:user_id]).must_be_nil
        assert_equal "Successfully logged out!", flash[:success]
      end

      it "wont log out a nonexistent user" do 
        perform_login(User.new)

        expect{delete logout_path}.wont_change "User.count"
        must_redirect_to root_path
      end 
    end
  end 

  describe "logged out / guest user" do

    describe "current" do
      it "responds with a redirect to the root path for the current user page" do
        get current_user_path

        must_redirect_to root_path
      end
    end

    describe "show" do
      it "responds with success when a user id exists" do
        get user_path(users(:ada).id)

        must_respond_with :success
      end

      it "responds with a not_found when a users id does not exist" do
        get user_path(-1)

        must_respond_with :not_found
      end
    end

    describe "edit" do 
      it "does not show an edit page for guest user, responds with a redirect and error message" do
        get edit_user_path

        must_redirect_to root_path
        assert_equal "You must be logged in to do that.", flash[:error]
      end 
    end

    describe "update" do 
      it "will redirect to the root path if the user is not logged in" do
        user = users(:gretchen)
        updated_user_data = {
          user: {
            uid: user.uid,
            merchant_name: "Grapes?",
            email: user.email,
            provider: user.provider,
            username: user.username
          }
        }
        expect {
          patch current_user_path, params: updated_user_data
        }.wont_change "User.count"
        must_redirect_to root_path
        assert_equal "You must be logged in to do that.", flash[:error]
      end
    end 

    describe "destroy" do
      it "won't log out a user that is not logged in" do
        delete logout_path 
        expect {delete logout_path}.wont_change "User.count"

        must_redirect_to root_path
        expect(session[:user_id]).must_be_nil
      end
    end 
  end 
end
