require "test_helper"

describe MerchantsController do
  let(:merchant_one) { merchants(:sponge) }
  
  describe "auth_callback" do
    it "logs in an exisiting merchant and redirects to the root route" do
      start_count = Merchant.count
      merchant = merchants(:sponge)
      perform_login(merchant)
      expect(session[:user_id]).must_equal merchant.id

      expect(Merchant.count).must_equal start_count
      must_redirect_to root_path
    end

    it "creates an account for a new user and redirects to the root route" do
      start_count = Merchant.count
      new_merchant = Merchant.new(username: "test_user", email: "test_user@git.com", UID: 1234567890, provider: "github")
      perform_login(new_merchant)
      expect(session[:user_id]).must_equal Merchant.last.id
      expect(Merchant.count).must_equal start_count + 1
      must_redirect_to root_path
    end

    it "redirects to the login route if given invalid merchant data" do
      start_count = Merchant.count
      new_merchant = Merchant.new(username: "Sam", email: nil)

      perform_login(new_merchant)

      expect { get auth_callback_path(:github) }.wont_change start_count
      must_redirect_to root_path
    end
  end


  describe "logged in merchants" do
    before do
      perform_login(merchants(:sponge))
    end

    describe "index" do
      it "will show a list of all merchants" do
        get merchants_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "will show my merchant dashboard page" do
        get merchant_path(merchants(:sponge).id)
        must_respond_with :success
      end

      it "will not allow access to other merchants' dashboard page" do
        get merchant_path(merchants(:star).id)
        must_respond_with :redirect
      end
    end
  end

  describe "guest users" do
    describe "index" do
      it "can access a list of all products" do
        get products_path

        must_respond_with :success
      end
    end

    # describe "show" do
    #   it "will not allow a guest user to see any merchants' dashboard page" do
    #     get merchant_path(merchants(:star).id)
    #     must_respond_with :redirect
    #   end
    # end
  end
end
