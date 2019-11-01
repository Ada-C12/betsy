require "test_helper"

describe ProductsController do
  describe "index" do 
    it "succeeds in getting products list" do
      get products_path
      
      must_respond_with :success
    end
  end
  
  
  describe "new" do 
    it "if user is logged in, succeeds" do
      perform_login
      
      get new_product_path
      
      must_respond_with :success
    end
    
    it "if user is not logged in, redirects to root path" do
      get new_product_path
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
    
    
  end
  
  describe "create" do
    
    it "if users is logged in, creates a new product with valid data" do      
      perform_login(User.first)
      
      new_product = { product:  {name: "new product", price: 149.99, qty: 5, user_id: session[:user_id]} }
      
      expect{ post products_path, params: new_product }.must_differ 'Product.count', 1
      
      new_product_id = Product.find_by(name: "new product").id
      
      must_respond_with :redirect
      must_redirect_to product_path(new_product_id)
      
    end
    
    it "if user is logged in, renders bad_request and does not update the DB" do
      perform_login(User.first)
      
      bad_product = { product:  {qty: 7, price: 149.99, qty: 5, description: "This product is new", status: "active"} }
      
      expect { post products_path, params: bad_product }.wont_change "Product.count"
      
      must_respond_with :success
      
    end
    
    it "if users is not logged in, redirects to root_path for" do      
      user = User.first
      
      new_product = { product:  {name: "new product", price: 149.99, qty: 5, user_id: user.id} }
      
      expect{ post products_path, params: new_product }.must_differ 'Product.count', 0
      
      must_respond_with :redirect
      must_redirect_to root_path
      
    end
    
  end
  
  describe "show" do
    let (:product) { Product.first }
    it "responds with success when showing an existing valid product" do
      id = product.id      
      
      get product_path(id)
      
      must_respond_with :success      
    end
    
    it "responds with 404 with an invalid product id" do
      id = "456456"      
      
      get product_path(id)
      
      must_respond_with :redirect      
    end
  end
  
  describe "edit" do
    let (:product) { Product.first }
    
    it "if user is logged in, can get the edit page for an existing task" do
      perform_login(User.first)
      
      get edit_product_path(product.id)
      must_respond_with :success      
    end
    
    it "if user is logged in, responds with redirect when getting the edit page for a non-existing product" do
      perform_login(User.first)
      
      bad_id = "5445"
      
      get edit_product_path(bad_id)
      
      must_respond_with :redirect
      must_redirect_to products_path
    end
    
    it "if user is not logged in, can get the edit page for an existing task" do
      
      get edit_product_path(product.id)
      
      must_respond_with :redirect
      must_redirect_to root_path     
    end
    
    it "if user is not logged in, responds with redirect when getting the edit page for a non-existing product" do
      bad_id = "5445"
      
      get edit_product_path(bad_id)
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
    
  end
  
  describe "update" do
    it "if user is logged in, can update an existing product with valid information accurately, and redirect" do
      perform_login(User.first)
      
      product = Product.first
      updates = { name: "updated product" }
      
      expect{ patch product_path(product.id), params: {product: updates}}.must_differ "Product.count", 0
      
      updated_product = Product.find(product.id)
      expect(updated_product.name).must_equal "updated product"
      
      must_respond_with :redirect
      must_redirect_to product_path(product.id)
    end
    
    it "if user is logged in, does not update any product if given an invalid id, and responds with a 404" do
      perform_login(User.first)
      product = Product.first
      bad_id = "bad-id"
      updates = { name: "updated product" }
      
      expect{ patch product_path(bad_id), params: {product: updates}}.must_differ "Product.count", 0
      
      must_respond_with :redirect
      must_redirect_to products_path
    end
    
    it "if user is logged in, does not update a product if the form data violates product validations" do
      perform_login(User.first)
      
      product = Product.first
      updates = { name: nil }
      
      expect{ patch product_path(product.id), params: {product: updates}}.must_differ "Product.count", 0
      
      must_respond_with :success
    end
    
    it "if user is not logged in, can not update a product" do           
      product = Product.first
      
      update_id = product.id
      updates = { name: "updated product" }
      
      expect{ patch product_path(update_id), params: {product: updates}}.must_differ "Product.count", 0
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
