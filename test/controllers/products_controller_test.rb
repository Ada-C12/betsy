require "test_helper"

describe ProductsController do
  let(:plant_one) { products(:aloe) }
  let(:plant_two) { products(:fern) }
  let(:plant_three) { products(:bird) }
  let(:category_one) { categories(:suc) }
  let(:merchant_one) { merchants(:bob) }

  describe "logged in merchants" do
    before do
      perform_login(merchant_one)
    end
    describe "index" do
      it "can get the index path" do
        get products_path

        must_respond_with :success
      end

      it "only views products if their status is active" do
        product = Product.first

        expect(product.status).must_equal true
      end

      it "will get all the products for a specific category" do
        plant_one.category_ids = category_one.id

        get category_products_path(category_one.id)

        must_respond_with :success
      end

      it "will respond with a 404 if the category does not exist" do
        get category_products_path(-1)

        must_respond_with :not_found
      end

      it "will get all the products for a specific merchant" do
        plant_one.merchant_id = merchant_one.id

        get merchant_products_path(merchant_one.id)

        must_respond_with :success
      end

      it "should respond with a 404 if merchant does not exist" do
        get merchant_products_path(-1)
        must_respond_with :not_found
      end
    end

    describe "show" do
      it "will show an individual product's page" do
        get product_path(products(:fern).id)

        must_respond_with :success
      end

      it "returns a 404 if the product doesn't exist" do
        get product_path(-1)

        must_respond_with :not_found
      end
    end

    describe "new" do
      it "will create a new product for a logged in user" do
        get new_product_path

        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a product with valid data" do
        # new_product = { product: { name: "Cinnamon Fern", price: 8, quantity: 20, description: "Tastes like cinnamon", photo_url: "https://i.imgur.com/7tkoo6m.jpg", status: true } }

        new_product = {
          product: { name: "Cinnamon fern",
                    price: 5, merchant_id: merchants(:bob).id },
        }
        perform_login

        expect {
          post products_path, params: new_product
        }.must_change "Product.count", 1
      end

      it "renders bad_request and does not update the DB for bogus data" do
        bad_product = { product: { name: nil,
                                   merchant: merchants(:bob),
                                   price: nil } }

        expect {
          post products_path, params: bad_product
        }.wont_change "Product.count"

        must_respond_with :bad_request
      end

      it "redirects to products page if no user is logged in" do
        @login_merchant = nil
        new_product = {
          product: { name: "Cinnamon Fern",
                     price: 8, quantity: 20,
                     description: "Tastes like cinnamon",
                     photo_url: "https://i.imgur.com/7tkoo6m.jpg",
                     status: true },
        }

        perform_login(@login_merchant)
        post products_path, params: new_product
        must_respond_with :redirect
      end
    end

    describe "edit" do
      it "will edit a specific merchant's product" do
        get edit_product_path(plant_one.id)

        must_respond_with :success
      end

      it "renders 404 not_found for a bogus product" do
        bogus_id = -1

        get edit_product_path(bogus_id)

        must_respond_with :not_found
      end
    end

    describe "update" do
      # Need to add Auth. Right now the result text is "Only logged in merchant can update"
      it "succeeds for valid data and an extant product ID" do
        updates = { product: { name: "Venus fly trap", price: 8 } }

        expect {
          patch product_path(plant_one), params: updates
        }.wont_change "Product.count"

        updated_product = Product.find_by(id: plant_one.id)
        # expect(flash[:result_text]).must_equal "Yay!"
        _(updated_product.name).must_equal "Venus fly trap"
        must_respond_with :redirect
        must_redirect_to product_path(plant_one.id)
      end

      it "renders 404 for a bogus product ID" do
        updated_product_hash = {
          product: {
            name: "Test plant",
          },
        }

        invalid_id = -1

        patch product_path(invalid_id), params: updated_product_hash

        must_respond_with :not_found
      end
    end

    describe "toggle active" do
      it "can activate a product" do
        plant_two.update(status: false)
        puts "****#{plant_two.status}"
        patch toggle_active_path(plant_two.id)

        expect((Product.find(plant_two.id)).status).must_equal true
      end

      it "cannot activate another merchant's product" do
        plant_three.update(status: false)

        patch toggle_active_path(plant_three.id)

        expect((Product.find(plant_three.id)).status).must_equal false
        expect(flash[:result_text]).must_equal "You may only change the status of your own products"
      end
    end

    describe "toggle inactive" do
      it "can retire a product" do
        patch toggle_inactive_path(plant_one.id)

        expect((Product.find(plant_one.id)).status).must_equal false
        # expect(flash[:result_text]).must_equal "You must be logged in"
      end

      it "cannot retire another merchant's product" do
        patch toggle_inactive_path(plant_three.id)

        expect((Product.find(plant_three.id)).status).must_equal true
        expect(flash[:result_text]).must_equal "You may only change the status of your own products"
      end
    end
  end

  describe "guest users" do
    describe "index" do
      it "allows the guest users to access all the products" do
        get products_path

        must_respond_with :success
      end
    end

    describe "new" do
      it "will not allow guest users to access the new product form" do
        get new_product_path

        must_respond_with :redirect

        must_redirect_to root_path
      end
    end

    describe "create" do
      it "does not create a product for a guest user" do
        new_product = { product: { name: "Cinnamon Fern",
                                   price: 8,
                                   quantity: 20,
                                   description: "Tastes like cinnamon",
                                   photo_url: "https://i.imgur.com/7tkoo6m.jpg",
                                   status: true } }

        expect {
          post products_path, params: new_product
        }.wont_change "Product.count"
      end
    end

    describe "edit" do
      it "will not allow a guest user to access the edit form" do
        get edit_product_path(plant_one)

        must_respond_with :redirect
        expect(flash[:status]).must_equal :failure
        expect(flash[:result_text]).must_equal "Only logged in merchants can edit their own products"
      end
    end

    describe "update" do
      it "will not allow a guest user to update a product" do
        updates = { product: { name: "Venus fly trap", price: 8 } }

        expect {
          patch product_path(plant_one), params: updates
        }.wont_change "Product.count"

        updated_product = Product.find_by(id: plant_one.id)
        _(updated_product.name).must_equal "Aloe plant"
        expect(flash[:status]).must_equal :failure
        expect(flash[:result_text]).must_equal "Only logged in merchants can update products"
        must_respond_with :not_found
      end
    end
  end
end
