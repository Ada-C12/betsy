require "test_helper"

describe Merchant do
  describe "instantiation" do
    it "can be instantiated" do
      
      new_merchant = Merchant.new(
      username: "Peter",
      email: "peter@gmail.com",
      uid: 90587023,
      provider: "github"
      )
      
      new_merchant.save!
      expect(new_merchant.valid?).must_equal true
    end
    
    it "will have the required fields" do
      merchant = Merchant.first
      expect(merchant).must_respond_to :username
      expect(merchant).must_respond_to :email
    end
  end
  
  describe "relationships" do
    it "can have many products" do
      merchant = Merchant.first
      
      expect(merchant.products.count).must_be :>=, 0
      merchant.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end
  
  describe "validations" do
    before do
      @merchant = Merchant.first
    end
    
    it "must have a username" do
      @merchant.username = nil
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages).must_include :username
      expect(@merchant.errors.messages[:username]).must_equal ["can't be blank"]
    end
    
    it "must have an email" do
      @merchant.email = nil
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages).must_include :email
      expect(@merchant.errors.messages[:email]).must_equal ["can't be blank"]
    end
    
    it "must have a uid" do
      @merchant.uid = nil
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages).must_include :uid
      expect(@merchant.errors.messages[:uid]).must_equal ["can't be blank"]
    end  
    
    it "must have a provider" do
      @merchant.provider = nil
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages).must_include :provider
      expect(@merchant.errors.messages[:provider]).must_equal ["can't be blank"]
    end
  end
  
  describe "fulfillments" do
    it "can properly get all orderproducts for a merchant" do
      merchant = merchants(:gyjin)
      fulfillment = merchant.fulfillments
      expect(fulfillment).must_be_instance_of Array
      expect(fulfillment.length).must_equal 2
      expect(fulfillment[0]).must_be_instance_of Orderproduct
    end
  end
end
