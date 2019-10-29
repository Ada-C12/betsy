require "test_helper"

describe MerchantsController do

  describe "Logged in Merchants" do 
   

    describe "current" do
      it "responds with success when given current merchants id" do
        perform_login(merchants(:brad))
        get current_merchant_path
        must_respond_with :success
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
        expect(session[:merchant_id]).must_equal merchant.id
        expect(Merchant.count).must_equal start_count
        expect(flash[:status]).must_equal :success
        expect(flash[:result_text]).must_equal "Logged in as returning merchant #{merchant.username}."
      end
  
      it "creates an account for a new merchant and redirects to the root route" do 
        start_count = Merchant.count
        merchant = Merchant.new(username: "Shandy", email: "shandy@beer.com", uid: 83358335, provider: "github")
  
        perform_login(merchant)
  
        expect(Merchant.count).must_equal start_count + 1
  
        merchant = Merchant.find_by(uid: merchant.uid)
        must_redirect_to root_path
        expect(session[:merchant_id]).must_equal merchant.id
        expect(flash[:status]).must_equal :success
        expect(flash[:result_text]).must_equal "Logged in as new merchant #{merchant.username}."
  
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
      end
    end

    describe "current" do 
      it "responds with a not found flash and redirects to root path when id given does not exist" do
       
        get current_merchant_path

        expect(flash[:error]).must_equal "You must be logged in as an authorized merchant to access this page."
  
        
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
      
  end

end
