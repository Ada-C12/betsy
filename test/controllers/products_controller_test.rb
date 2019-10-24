require "test_helper"

describe ProductsController do
  describe "index action" do

    describe "index action given category_id" do
        
      it "gives back a success response if given a valid category id" do
        valid_category = Category.first
        assert_not_nil(valid_category)
        get category_products_path(valid_category.id)
        must_respond_with :success
      end

      it "gives back a not found response if given an invalid category id" do
        invalid_category_id = -1
        invalid_category = Category.find_by(id: invalid_category_id)
        assert_nil(invalid_category)
        get category_products_path(invalid_category_id)
        must_respond_with :not_found
      end
    end
  end
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
end
