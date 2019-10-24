require "test_helper"

describe WizardsController do
  let(:wizard1) { wizards(:wizard1) }
  let(:wizard_no_products) { wizards(:wizard_no_products) }

  describe "products" do
    it "responds with success when listing products for existing wizard" do
      get wizards_products_path(wizard1.id)

      must_respond_with :success
    end

    it "responds with success when selected wizard has no products" do
      get wizards_products_path(wizard_no_products.id)

      must_respond_with :success
    end
    
    it "only includes projects for selected wizard" do
      wizard1.products.each do |product|
        expect(product.wizard).must_equal wizard1
      end
    end
    
    it "redirects if wizard does not exist" do
      invalid_id = -20

      get wizards_products_path(invalid_id)

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
