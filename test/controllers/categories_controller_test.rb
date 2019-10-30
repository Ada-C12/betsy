require "test_helper"

describe CategoriesController do
  let(:wizard1) { wizards(:wizard1) }

  describe "new" do
    it "succeeds" do
      get new_category_path
      
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "creates a work with valid data for a real category" do
      perform_login(wizard1)

      new_category = { category: { name: "Magic Fish" } }
      
      expect {
        post categories_path, params: new_category
      }.must_change "Category.count", 1
      
      must_respond_with :redirect
      must_redirect_to wizard_path(wizard1.id)
    end
    
    it "responds with bad_request and does not update the databse for invalid data" do
      invalid_category = { category: { name: nil } }
      
      expect {
        post categories_path, params: invalid_category
      }.wont_change "Category.count"
      
      must_respond_with :bad_request
    end
  end
end
