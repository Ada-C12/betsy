require "test_helper"

describe ProductsController do
  let(:wizard1) { wizards(:wizard1) }
  let(:wizard_no_products) { wizards(:wizard_no_products) }
  let(:product) { products(:product1) }

  describe "Guest users" do
    describe "index action" do
      it "gives back a successful response" do
        get products_path

        must_respond_with :success
      end
      
      it "gives back a successful response if there are no products" do
        Product.destroy_all
        
        get products_path
        
        must_respond_with :success
        
      end
    end

    describe "index of products by wizard" do
      it "responds with success when listing products for existing wizard" do
        get wizard_products_path(wizard1.id)

        must_respond_with :success
      end

      it "responds with success when selected wizard has no products" do
        get wizard_products_path(wizard_no_products.id)

        must_respond_with :success
      end

      it "only includes projects for selected wizard" do
        wizard1.products.each do |product|
          expect(product.wizard).must_equal wizard1
        end
      end
      
      it "redirects to root if wizard does not exist" do
        invalid_id = -20

        get wizard_products_path(invalid_id)

        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "index action given category_id" do
        
      it "gives back a success response if given a valid category id" do
        valid_category = Category.first
        assert_not_nil(valid_category)
        get category_products_path(valid_category.id)
        must_respond_with :success
      end

      it "redirects to root if given an invalid category id" do
        invalid_category_id = -1
        invalid_category = Category.find_by(id: invalid_category_id)
        assert_nil(invalid_category)
        get category_products_path(invalid_category_id)
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

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
end
