require "test_helper"

describe Merchant do
  let(:new_merchant) {
    Merchant.new(
      username: "new merchant",
      email: "merchant@store.com",
      uid: "12345",
      provider: "github"
    )
  }
  
  describe "instantiation" do
    it "can instantiate a valid merchant" do 
      expect(new_merchant.save).must_equal true
    end
    
    it "will have the required fields" do
      new_merchant.save!
      merchant = Merchant.last
      
      [:username, :email, :uid, :provider].each do |field|
        expect(merchant).must_respond_to field
      end
    end
  end
  
  describe "relationships" do
    it "can have many products" do 
      product_1 = products(:heineken)
      product_2 = products(:sapporo)
      product_3 = products(:corona)
      
      new_merchant.products << product_1
      new_merchant.products << product_2
      new_merchant.products << product_3
      
      new_merchant.save!
      
      expect(new_merchant.products.count).must_equal 3
      
      new_merchant.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end
  
  describe "validations" do
    describe "name validation" do
      it "cannot create a merchant with no username" do 
        new_merchant.username = nil
        
        expect(new_merchant.valid?).must_equal false
        expect(new_merchant.errors.messages).must_include :username
        expect(new_merchant.errors.messages[:username]).must_include "can't be blank"
      end
      
      it "must have a unique name" do
        new_merchant.username = "radbrad" 
        
        expect(new_merchant.valid?).must_equal false
        expect(new_merchant.errors.messages).must_include :username
        expect(new_merchant.errors.messages[:username]).must_include "has already been taken" 
      end
    end
    
    describe "uid validations" do 
      it "cannot create a merchant with no uid" do 
        new_merchant.uid = nil
        
        expect(new_merchant.valid?).must_equal false
        expect(new_merchant.errors.messages).must_include :uid
        expect(new_merchant.errors.messages[:uid]).must_include "can't be blank"
      end
      
      it "must have a unique uid" do 
        new_merchant.uid = 13371337
        
        expect(new_merchant.valid?).must_equal false
        expect(new_merchant.errors.messages).must_include :uid
        expect(new_merchant.errors.messages[:uid]).must_include "has already been taken"
      end
    end
    
    describe "email" do 
      it "cannot create a merchant with no email" do 
        new_merchant.email = nil
        
        expect(new_merchant.valid?).must_equal false
        expect(new_merchant.errors.messages).must_include :email
        expect(new_merchant.errors.messages[:email]).must_include "can't be blank"
      end
      
      it "must have a unique email" do 
        new_merchant.email = "radbrad@frat.com"
        
        expect(new_merchant.valid?).must_equal false
        expect(new_merchant.errors.messages).must_include :email
        expect(new_merchant.errors.messages[:email]).must_include "has already been taken"
      end
    end
  end
  
  describe "custom methods" do 
    describe "build_from_github" do 
      it "creates a new merchant" do 
        auth_hash = {
          provider: "github",
          uid: 12345 ,
          "info" => {
            "email" => "merchant@store.com",
            "nickname" => "new merchant"
          }
        }
        
        merchant = Merchant.build_from_github(auth_hash)
        merchant.save!
        
        expect(Merchant.count).must_equal 5
        
        expect(merchant.provider).must_equal auth_hash[:provider]
        expect(merchant.uid).must_equal auth_hash[:uid]
        expect(merchant.username).must_equal auth_hash["info"]["nickname"]
        expect(merchant.email).must_equal auth_hash["info"]["email"]
      end
    end
    
    describe "find_merchants_orderitems" do
      it "returns an array of a merchant's orderitems" do
        current_merchant = merchants(:brad)
        result = Merchant.find_merchants_orderitems(current_merchant)
        expect(result.first.product.merchant.id).must_equal current_merchant.id
      end 
    end
    
    describe "calculate_total_revenue" do
      it "returns the total revenue for a merchant's orderitems" do
        current_merchant = merchants(:brad)
        result = Merchant.calculate_total_revenue(current_merchant)
        expect(result).must_equal 181.1
      end
      
      it "returns zero for the total revenue if merchant has no orderitems" do
        current_merchant = merchants(:leo)
        result = Merchant.calculate_total_revenue(current_merchant)
        expect(result).must_equal 0
      end
      
    end 
    
    describe "calc_rev_by_status" do
      it "returns the total revenue for a merchant's orderitems" do
        current_merchant = merchants(:brad)
        result1 = Merchant.calc_rev_by_status(current_merchant, "true")
        result2 = Merchant.calc_rev_by_status(current_merchant, "false")
        
        expect(result1).must_equal 14.0
        expect(result2).must_equal 167.1
      end
      
      it "returns zero for the total revenue if merchant has no orderitems" do
        current_merchant = merchants(:leo)
        result = Merchant.calc_rev_by_status(current_merchant, "true")
        expect(result).must_equal 0
      end
    end
    
    
  end
  
end
