require "test_helper"
require 'pry'
describe ProductsController do
  let(:wizard1) { wizards(:wizard1) }
  let(:wizard_no_products) { wizards(:wizard_no_products) }
  let(:product) { products(:product1) }
  let(:product3) { products(:product3) }
  let(:category1) { categories(:category1) } 
  let(:category5) { categories(:category5) }
  let(:valid_product_params) {
    {
      product: {
        name: "Ancient Amulet",
        description: "Amulet that also qualifies as an artifact",
        stock: 1,
        # photo_url,
        price: 23.00,
        category_ids: [category1.id, category5.id]        
      }
    }
  }
  let(:invalid_product_params) { 
    {
      product: {
        name: nil,
        description: "Amulet that also qualifies as an artifact",
        stock: 0,
        # photo_url,
        price: 0.00,
        category_ids: [category1.id, category5.id]        
      }
    }
  }

  describe "Guest Users" do
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

    describe "new action" do
      it "responds with redirect since user is guest and not logged in" do
        get new_wizard_product_path(wizard1.id)
        must_respond_with :redirect
      end
    end

    describe "create action" do
      it "responds with redirect since user is guest and not logged in" do
        post wizard_products_path(wizard1.id), params: valid_product_params
        must_respond_with :redirect
      end
    end

    describe "edit action" do
      it "responds with redirect since user is guest and not logged in" do
        get edit_product_path(product.id)
        must_respond_with :redirect
      end
    end

    describe "update action" do
      it "responds with redirect since user is guest and not logged in" do
        patch product_path(product.id), params: valid_product_params
        must_respond_with :redirect
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

    describe "show action" do
      it "responds with success when showing an existing valid product" do
        get product_path(product.id)

        must_respond_with :success
      end

      it "responds with 404 with an invalid product id " do
        get product_path(-1)

        must_respond_with :not_found
      end
    end

    describe "new action" do
      it "redirects" do
        get new_wizard_product_path(wizard1.id)
        must_respond_with :redirect
      end
    end

    describe "create action" do
      it "redirects" do
        post wizard_products_path(wizard1.id), params: valid_product_params
        must_respond_with :redirect
      end
    end

    describe "edit action" do
      it "redirects" do
        get edit_product_path(product.id)
        must_respond_with :redirect
      end
    end

    describe "update action" do
      it "redirects" do
        patch product_path(product.id), params: valid_product_params
        must_respond_with :redirect
      end
    end

  end

  describe "Logged In Users Only" do
    before do
      perform_login(wizard1)
    end
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

    describe "new action" do
      it "succeeds if user is the Wizard given in params and Wizard ID matches logged in user's ID" do
        get new_wizard_product_path(wizard1.id)
        must_respond_with :success
      end

      it "redirects if correct wizard is not logged in" do
        different_wizard = wizard_no_products
        get new_wizard_product_path(different_wizard.id)
        must_respond_with :redirect
      end
    end

    describe "create action" do
      it "creates a product given valid product data" do
        expect {
          post wizard_products_path(wizard1.id), params: valid_product_params
          # binding.pry
        }.must_change "Product.count", 1

        must_respond_with :redirect
      end

      it "redirects if correct wizard is not logged in" do
        different_wizard = wizard_no_products
        post wizard_products_path(different_wizard.id), params: valid_product_params
        must_respond_with :redirect
      end

      it "responds with :bad_request and does not update the DB for bogus data" do
        expect {
          post wizard_products_path(wizard1.id), params: invalid_product_params
        }.wont_change "Product.count"

        must_respond_with :bad_request
      end

      it "responds with :not_found if Wizard is not found from params[:wizard_id]" do
        bogus_wizard_id = -1
        post wizard_products_path(bogus_wizard_id), params: valid_product_params
        must_respond_with :not_found
      end
      
    end

    describe "edit action" do
      it "succeeds if user is the Wizard given in params and Wizard ID matches logged in user's ID" do
        get edit_product_path(product.id)
        must_respond_with :success
      end

      it "redirects if logged in wizard is trying to edit a product they do not own" do
        get edit_product_path(product3.id)
        must_respond_with :redirect
      end
    end

    describe "update action" do
      it "updates a product given valid product and wizard data" do
        refute(product.name == valid_product_params[:product][:name])
        expect {
          patch product_path(product.id), params: valid_product_params
        }.wont_change "Product.count"

        must_respond_with :redirect
        expect(Product.find_by(id: product.id).name).must_equal valid_product_params[:product][:name]
      end

      it "redirects if wizard does not own the product" do
        patch product_path(product3.id), params: valid_product_params
        must_respond_with :redirect
      end

      it "responds with :bad_request and does not update the DB for bogus data" do
        expect {
          patch product_path(product.id), params: invalid_product_params
        }.wont_change "Product.count"

        must_respond_with :bad_request
      end

      it "responds with :not_found if Wizard is not found from params[:wizard_id]" do
        bogus_wizard_id = -1
        post wizard_products_path(bogus_wizard_id), params: valid_product_params
        must_respond_with :not_found
      end
    end
  end
end
