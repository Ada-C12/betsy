require "test_helper"

# ADD AUTHENTICATION
# ADD AUTHORIZATION

describe ProductsController do
  describe "index" do
    it "gives back a successful response" do
      get products_path

      must_respond_with :success
    end

    it "gives back a sucessful response when there is no products" do
      get products_path
      
      must_respond_with :success
    end
  end 

  describe "show" do
    it "responds with a success when given id exists" do
      product = products(:heineken)

      get product_path(product.id)

      must_respond_with :success
    end

    it "redirects to root when given id doesn't exist" do
      get product_path("-1")

      must_redirect_to root_path
    end
  end

  describe "new" do
    it "can get the new product page" do
      get new_product_path
      must_respond_with :success
    end 
  end

  describe "create" do
    it "creates a product sucessfully with valid data, and redirects the user to the product page" do
      merchant = Merchant.create(username: "jake", email: "jakw123@gmail.com", uid: 12232234, provider: "github")

      product_hash = {
        product: {
          name: "Growler",
          description: "Keeps your beer fresh!",
          price: 30.0,
          photo_url: "https://images-na.ssl-images-amazon.com/images/I/51NR%2BJ9lLNL._SY679_.jpg",
          stock: 5,
          merchant_id: merchant.id,
          retired: false,
        }
      }

      expect {
        post products_path, params: product_hash
      }.must_differ 'Product.count', 1

      new_product = Product.find_by(name: product_hash[:product][:name])
      expect(new_product.name).must_equal product_hash[:product][:name]

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

  end

  describe "edit" do
    it "can get the edit page" do
      product = products(:heineken)
      get edit_product_path(product.id)
    end

    it "will respond with a not_found when attempting to edit a nonexistent product" do
      get edit_product_path(-1)
      must_redirect_to products_path
    end 
  end

  describe "update" do
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

  # toggle_retire



end
