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

  # new

  # edit

  # create

  # update

  # destroy



end
