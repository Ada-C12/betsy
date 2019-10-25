require "test_helper"

describe MerchantsController do
  
  #let(:merchant) { merchants(:brad) }

  describe "Logged in Merchants" do 
    before do 
      perform_login(merchants(:brad))
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
  end

  describe "Guest Users" do 
    describe "index" do
      it "responds with success when there are many merchants" do
        get merchants_path
        must_respond_with :success
      end
    
    
      it "responds with success when there are no merchants" do
      # merchants = Merchant.all
      # merchants.each do |merchant|
      #   merchant.delete
      # end
     
      get merchants_path
      must_respond_with :success
      end
    end

    describe "auth_callback" do
      it "logs in an existing merchant and redirects to the root route" do
        start_count = Merchant.count
  
        merchant = merchants(:brad)
        perform_login(merchant)
  
        must_redirect_to root_path
        session[:merchant_id].must_equal merchant.id
        Merchant.count.must_equal start_count
        expect(flash[:success]).must_equal "Logged in as returning merchant #{merchant.username}."
      end
  
      it "creates an account for a new merchant and redirects to the root route" do 
        start_count = Merchant.count
        merchant = Merchant.new(username: "Shandy", email: "shandy@beer.com", uid: 83358335, provider: "github")
  
        perform_login(merchant)
  
        Merchant.count.must_equal start_count + 1
  
        merchant = Merchant.find_by(uid: merchant.uid)
        must_redirect_to root_path
        session[:merchant_id].must_equal merchant.id
        expect(flash[:success]).must_equal "Logged in as new merchant #{merchant.username}."
  
      end
  
      it "redirects to the login if given invalid merchant data" do 
        start_count = Merchant.count
  
        merchant = merchants(:brad)
        merchant.uid = nil
        merchant.save
        perform_login(merchant)
  
        expect {
          get auth_callback_path(:github)
        }.wont_change "Merchant.count"
  
        must_redirect_to root_path
        expect(session[:merchant_uid]).must_be_nil
  
        # expect(flash[:success]).must_equal "Could not create new merchant account: #{merchant.errors.messages}"
  
        # merchant = Merchant.new
        # OmniAuth.config.mock_auth[:github] = 
        # OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        
        # expect {
        #   get auth_callback_path(:github)
        # }.wont_change "Merchant.count"
  
        # must_redirect_to root_path
        # expect(session[:merchant_id]).must_be_nil
        # expect(flash[:success]).must_equal "Could not create new merchant account: #{merchant.errors.messages}"
  
      end
    end
  end

end
