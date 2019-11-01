require "test_helper"

describe HomepagesController do
  describe "index" do 
    it "can get the index/root path" do 
      # Act
      get root_path

      # Arrange
      must_respond_with :success
    end
  end 
end
  
  