require "test_helper"

describe CategoriesController do
  describe "index action" do
    it "gives back a successful response" do
      get categories_path

      must_respond_with :success
    end
  end

  describe 'show action' do
    it 'responds with a success when id given exists' do

      get category_path(categories(:valid_category).id)

      must_respond_with :success

    end

    it 'responds with a not_found when id given does not exist' do

      get category_path("-500")

      must_respond_with :not_found
    end
  end

  describe "new" do 
    it "if user is logged in, succeeds" do
      perform_login
      
      get new_category_path
      
      must_respond_with :success
    end
    
    it "if user is not logged in, redirects to root path" do
      get new_category_path
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
    
  end

  describe "create logged in" do
    it 'creates a new category successfully and redirects the user to the category page' do
      perform_login(User.first)

      category_hash = {
        category: {
          name: "New Category"
        }
      }

      expect {
        post categories_path, params: category_hash
      }.must_differ 'Category.count', 1

      new_category_id = Category.find_by(name: "New Category").id

      must_respond_with :redirect
      must_redirect_to category_path(new_category_id)    
    end

    it "does not create a new category with bad data" do
      perform_login(User.first)

      category_hash = {
        category: {
          name: ""
        }
      }

      expect {
        post categories_path, params: category_hash
      }.wont_differ 'Category.count'

      assert_equal "Category not successfully saved", flash[:result_text]
    end
  end
  
  describe "create not logged in" do

    it "if users is not logged in, renders page" do      
      bad_category_hash = {
        category: {
          name: "New Category"
        }
      }
      
      expect { post categories_path, params: bad_category_hash }.wont_change "Category.count"

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "update" do
    it "if user is logged in, can update an existing category with valid information accurately, and redirect" do
      perform_login(User.first)

      category = categories(:valid_category)
      updates = { name: "updated category" }
      
      expect{ patch category_path(category.id), params: {category: updates}}.must_differ "Category.count", 0
      
      updated_category = Category.find(category.id)
      expect(updated_category.name).must_equal "updated category"
      
      must_respond_with :redirect
      must_redirect_to category_path(category.id)
    end
    
    it "if user is logged in, does not update any category if given an invalid id, and responds with a 404" do
      perform_login(User.first)
      
      bad_id = -500
      updates = { name: "updated category" }
      
      expect{ patch category_path(bad_id), params: {category: updates}}.must_differ "Category.count", 0
      
      must_respond_with :redirect
      must_redirect_to categories_path
    end
    
    it "if user is logged in, does not update a category if the form data violates category validations" do
      perform_login(User.first)
      
      category = Category.first
      updates = { name: nil }
      
      expect{ patch category_path(category.id), params: {category: updates}}.must_differ "Category.count", 0
      
      must_respond_with :success
    end
    
    it "if user is not logged in, can not update a category" do           
      category = Category.first
      
      update_id = category.id
      updates = { name: "updated category" }
      
      expect{ patch category_path(update_id), params: {category: updates}}.must_differ "Category.count", 0
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe 'edit' do
    let (:category) { categories(:valid_category) }
    
    it "if user is logged in, can get the edit page for an existing category" do
      perform_login(User.first)
      
      get edit_category_path(category.id)
      must_respond_with :success      
    end
    
    it "if user is logged in, responds with redirect when getting the edit page for a non-existing category" do
      perform_login(User.first)
      
      bad_id = "5445"
      
      get edit_category_path(bad_id)
      
      must_respond_with :redirect
      must_redirect_to categories_path
    end
    
    it "if user is not logged in, can get the edit page for an existing category" do
      
      get edit_category_path(category.id)
      
      must_respond_with :redirect
      must_redirect_to root_path     
    end
    
    it "if user is not logged in, responds with redirect when getting the edit page for a non-existing category" do
      bad_id = "5445"
      
      get edit_category_path(bad_id)
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
