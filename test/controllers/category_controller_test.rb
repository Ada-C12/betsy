require "test_helper"

describe CategoryController do 
  describe "index action" do 
  
    it "display a successful message" do 
      get category_path must_respond_with: success 
    end 

    it "display success if there are no categories available" do 
      get category_path must_respond_with: success 
    end 
  end 
  
  describe "create action" do 
    
    
    it "if there is no input, should not let the guest create a new category" do 
      
    end 

    
    it "guest user cannot create a new category" do 
      
    end 

    
    it "Merchant can create a new  category" do 
     
    end 
  end 
end