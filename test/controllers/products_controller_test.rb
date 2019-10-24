require "test_helper"

describe ProductsController do

  let (:product) {
    Product.create name: "ice sword", price: 1500, description: "wielded by Jack Frost", stock: 10, wizard: "zedzorander", categories: "artifact"
  }
  describe "index action" do

    it "gives back a successful response" do

      get products_path

      must_respond_with :success
    end

    it "gives back a successful response if there are no products" do
      
      Product.destroy_all
      # product = products(:product1)
      # no_product = product.destroy

      get products_path

      must_respond_with :success

    end

  end
end
