require "test_helper"

describe ProductsController do
  describe "Guest users" do 
    it "can access the homepage" do
      get root_path
      must_respond_with :success
    end

    it "can access products index page" do
      product = products(:heineken)
      get product_path(product.id)
      must_respond_with :success
    end 

    it "can access the product details page" do
      product = products(:heineken)
      get product_path(product.id)
      must_respond_with :success
    end 

    it "will be redirected to root when on product details if product id doesn't exist" do
      get product_path("-1")
      must_redirect_to root_path
    end 

    it "can't access the new product form" do
      get new_product_path
      must_redirect_to root_path
    end

    it "can't access the edit product form" do
      product = products(:heineken)
      get edit_product_path(product.id)
      must_redirect_to root_path
    end
  end
  
  describe "Logged in users" do 
    before do
      perform_login(merchants(:brad))
    end 

    it "can get the new product page" do
      get new_product_path
      must_respond_with :success
    end 

    it "creates a product sucessfully with valid data, and redirects the user to the product page" do

      product_hash = {
        product: {
          name: "Growler",
          description: "Keeps your beer fresh!",
          price: 30.0,
          photo_url: "https://images-na.ssl-images-amazon.com/images/I/51NR%2BJ9lLNL._SY679_.jpg",
          stock: 5,
          merchant_id: session[:merchant_id],
          retired: false,
        }
      }

      expect {
        post products_path, params: product_hash
      }.must_differ 'Product.count', 1

      new_product = Product.find_by(name: product_hash[:product][:name])
      expect(new_product.name).must_equal product_hash[:product][:name]
      expect(new_product.merchant_id).must_equal session[:merchant_id]
    end

    it "does not create a product with invalid data, and renders new form" do
      bad_product_hash = {
        product: {
          name: nil,
          description: "Keeps your beer fresh!",
          price: 30.0,
          photo_url: "https://images-na.ssl-images-amazon.com/images/I/51NR%2BJ9lLNL._SY679_.jpg",
          stock: 5,
          merchant_id: nil,
          retired: false,
        }
      }

      expect {
        post products_path, params: bad_product_hash
      }.wont_change 'Product.count'

      must_respond_with :bad_request
      assert_template :new
    end

    it "can get the edit page" do
      product = products(:heineken)
      get edit_product_path(product.id)
    end

    it "will respond with a not_found when attempting to edit a nonexistent product" do
      get edit_product_path(-1)
      must_redirect_to products_path
    end 

    describe "update for logged in users" do
      before do
        @merchant = Merchant.create(username: "jake", email: "jakw123@gmail.com", uid: 12232234, provider: "github")
        @product = Product.create(
          name: "Growler",
          description: "Keeps your beer fresh!",
          price: 30.0,
          photo_url: "https://images-na.ssl-images-amazon.com/images/I/51NR%2BJ9lLNL._SY679_.jpg",
          stock: 5,
          merchant_id: @merchant.id,
          retired: false,
        )
      end
  
      it "can update an existing product" do
        updated_product_data = {
          product: {
            name: "Coozie",
            description: "Keeps your beer fresh!",
            price: 50.0,
            photo_url: "https://images-na.ssl-images-amazon.com/images/I/51NR%2BJ9lLNL._SY679_.jpg",
            stock: 5,
            merchant_id: @merchant.id,
            retired: false,
          }
        }
  
        patch product_path(@product.id), params: updated_product_data
        expect(Product.find_by(id: @product.id).price).must_equal 50.0
        expect(Product.find_by(id: @product.id).name).must_equal "Coozie"
      end
  
      it "can't update an existing product given the wrong params" do
        wrong_product_data = {
          product: {
            name: "Growler",
            description: "Keeps your beer fresh!",
            price: 30.0,
            photo_url: "https://images-na.ssl-images-amazon.com/images/I/51NR%2BJ9lLNL._SY679_.jpg",
            stock: -1,
            merchant_id: @merchant.id,
            retired: false,
          }
        }
  
        patch product_path(@product.id), params: wrong_product_data
        expect(Product.find_by(id: @product.id).stock).must_equal 5
        
        must_respond_with :bad_request
        assert_template :edit
      end
    end
    
    describe "toggle_retire" do
      it "will set the retired value to true if false" do
        product = products(:sapporo)
        params = {
          product: {
            retired: true,
          }
        }
  
        patch "/products/#{product.id}/toggle_retire", params: params
        product.reload
        expect(product.retired).must_equal true
      end
  
      it "will set the retired value to false if true" do
        product = products(:corona)
        params = {
          product: {
            retired: false,
          }
        }
  
        patch "/products/#{product.id}/toggle_retire", params: params
        product.reload
        expect(product.retired).must_equal false
      end
    end
  end 
end