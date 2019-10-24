require "test_helper"

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
        }
      }

      # p product_hash[:product].errors.messages
      p merchant.inspect
      
      expect {
        post products_path, params: product_hash
      }.must_differ 'Product.count', 1

      new_product = Product.find_by(name: product_hash[:product][:name])
      expect(new_product.name).must_equal product_hash[:product][:name]

    end

    it "does not create a product with invalid data, and renders edit form" do
    end

  end

  # edit

  # update

  # destroy



end
