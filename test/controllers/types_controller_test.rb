require "test_helper"

describe TypesController do
  
  before do
    merchant = perform_login
  end
  
  describe "show" do 
    
    it "will responds with success when the given type_id exist" do
      
      valid_type = Type.first
      get type_path(valid_type)
      must_respond_with :success
    end
    
    it "will return a 404 if type does not exist" do 
      get type_path("apple")
      must_respond_with :redirect
      
    end
    
  end
  
  describe "new" do
    it "will respond with success" do
      get new_type_path
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "will create a new, real category" do
      new_type_hash = { 
        type: {
          name: "smooth"
        }
      }
      expect { post types_path, params: new_type_hash }.must_change 'Type.count', 1
      must_respond_with :redirect
    end #not working, will come back to. 
    
    it "will return bad request for errors" do
      #arrange
      new_type_hash = { 
        type: {
          name: nil
        }
      }
      
      #act
      expect { post types_path, params: new_type_hash }.wont_change 'Type.count'
      must_respond_with :bad_request
      #assert
    end
  end#end of create
  
end#end of types controller
