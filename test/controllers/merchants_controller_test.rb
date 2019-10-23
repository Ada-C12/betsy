require "test_helper"

describe MerchantsController do
  
  let(:merchant) { merchants(:brad) }

  describe "index" do
    it "responds with success when there are many merchants" do
      get merchants_path
      must_respond_with :success
    end
  
  
    it "responds with success when there are no merchants" do
    get merchants_path
    must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when id given exists" do
      get merchant_path(:brad)
      must_respond_with :found
    end

    it "responds with a not found flash and redirects to root path when id given does not exist" do
      merchant_id = -1
      get merchant_path(merchant_id)

      expect(flash[:warning]).must_equal "Merchant with id #{merchant_id} was not found."
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "auth_callback" do
    it "logs in an existing merchant and redirects to the root route" do
      start_count = Merchant.count

      user = merchants(:brad)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      get auth_callback_path(:github)
      must_redirect_to root_path
      session[:user_id].must_equal user.id
      Merchant.count.must_equal start_count
    end
  end
end
