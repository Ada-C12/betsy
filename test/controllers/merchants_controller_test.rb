require "test_helper"
require "pry"

describe MerchantsController do
  describe "index" do
    it "should display all merchants" do
      get merchants_path 
      must_respond_with :success
    end
    
    it "should not break if there are no merchants" do 
      Merchant.destroy_all
      get merchants_path
      must_respond_with :success
    end
  end
  
  describe "show" do
    
    it "should respond with success when given a valid merchant" do
      merchant_one = merchants(:merchant_one)
      
      get merchant_path(merchant_one.id)
      must_respond_with :success
    end
    
    it "should respond with redirect with an invalid merchant" do 
      get merchant_path(-1)
      must_respond_with :error
      must_redirect_to merchants_path
    end
  end
  
  
  describe "create" do
    it "can create a new merchant" do
      new_merchant = Merchant.new(username:"Kathy", email: "whatev@git.com", uid: 473837 )
      
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_merchant))
      # get auth_github_callback_path
      expect{ get auth_github_callback_path }.must_change "Merchant.count", 1
      
      must_redirect_to merchants_path
      
      
      # new_merchant_params = {
      #   merchant: {
      #     uid: 567,
      #     nickname: "Mr. Smith",
      #     email: "smith@adadev.org"
      #   }
      # }
      
      # expect {
      #   post merchants_path, params: new_merchant_params 
      # }.must_change "Merchant.count", 1
      
      # new_merchant = Merchant.find_by(uid: new_merchant_params[:merchant][:uid])
      # expect(new_merchant.username).must_equal new_merchant_params[:merchant][:username]
      
      # must_respond_with :redirect
      # must_redirect_to merchant_path(new_merchant)
    end
    
    #Choosing not to include edit, update, or destroy
    #Merchant information is coming from GitHub OAuth 
    #We do not see a need to destroy merchant
  end
  
end
