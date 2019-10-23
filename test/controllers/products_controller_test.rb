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

  # show

  # new

  # edit

  # create

  # update

  # destroy



end
