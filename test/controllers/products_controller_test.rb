require "test_helper"

describe ProductsController do
  let(:product) { products(:product1) }

  describe "show" do
    it "responds with success when showing an existing valid product" do
      get product_path(product.id)

      must_respond_with :success
    end

    it "responds with 404 with an invalid product id " do
      get product_path(-1)

      must_respond_with :not_found
    end
  end
end
