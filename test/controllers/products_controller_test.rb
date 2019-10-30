require "test_helper"

describe ProductsController do
  let(:product_hash) {
    {
      product: {
        name: "new product",
        price: 20.0,
        stock: 20,
        img_url: "new_img.com",
        category_ids: [categories(:strawberry).id],
        description: "description of a new product"
      }
    }
  }

  let(:update_product_hash) {
    {
      product: {
        name: "lemon product",
        price: 20.0,
        stock: 20,
        img_url: "new_img.com",
        category_ids: [categories(:strawberry).id],
        description: "description of a new product"
      }
    }
  }

  let(:invalid_product_hash) {
    {
      product: {
        name: "new product",
        price: nil,
        stock: nil,
        img_url: "new_img.com",
        description: "description of a new product"
     }
    }
  }
   
  describe "not logged in" do
    describe "index action" do
      it "gives back a successful response when provided no params" do
        get products_path
        must_respond_with :success
      end
      it "gives back a successful response when provided category_id" do
        category = categories(:lemon)
        get category_products_path(category)
        must_respond_with :success
      end
    
      it "returns 404 response when no category found" do
        get category_products_path(-1)
        must_respond_with :not_found
      end
    end
    
    describe "show action" do
      it "responds with a success when id given exists" do
        product = products(:lemon_shirt)
        get product_path(product.id)
        must_respond_with :success
      end
  
      it "responds with a not_found when id given does not exist" do
        get product_path(0)
        must_respond_with :not_found
      end
    end

    describe "new action" do
      it "redirects user to root path if no merchant logged in" do
        get new_product_path
        must_redirect_to root_path
      end
    end

    describe "create action" do
      it "cannot create a new product if no merchant logged in, and redirects the user to root path" do
        expect {
          post products_path, params: product_hash
        }.must_differ "Product.count", 0

        must_redirect_to root_path
      end
    end

    describe "edit action" do
      it "redirects user to root path if no merchant logged in" do
        product = products(:lemon_shirt)

        get edit_product_path(product.id)

        must_redirect_to root_path
      end
    end

    describe "update action" do
      it "cannot update a product if no merchant logged in, and redirects the user to the product page" do
        existing_product = products(:lemon_shirt)
  
        expect {
          patch product_path(existing_product.id), params: update_product_hash
        }.wont_differ "Product.count"
  
        find_product = Product.find_by(id: existing_product.id)
  
        expect(find_product.name).must_equal existing_product.name
        expect(find_product.price).must_equal existing_product.price
        expect(find_product.stock).must_equal existing_product.stock
        expect(find_product.img_url).must_equal existing_product.img_url
        expect(find_product.description).must_equal existing_product.description
        expect(find_product.category_ids.first).must_equal existing_product.categories.first.id
  
        must_redirect_to root_path
      end
    end

    describe "destroy action" do
      it "redirects to products index page and deletes no products if no merchant is logged in" do
        product = products(:lemon_shirt)
  
        expect {
          delete product_path(product.id)
        }.wont_differ "Product.count"
  
        must_redirect_to root_path
      end
    end
  end
  
  describe "logged in user" do
    before do
      @user = users(:ada)
      perform_login(@user)
    end

    describe "new action" do
      it "gives back a successful response if a merchant logged in" do
        get new_product_path
        must_respond_with :success
      end
    end
    
    describe "create action" do
      it "creates a new product successfully with valid data by a logged in merchant and redirects to the product page if the user has a merchant name" do
        expect {
          post products_path, params: product_hash
        }.must_differ "Product.count", 1
  
        must_redirect_to product_path(Product.find_by(name: "new product"))
      end
  
      it "creates a new product successfully with valid data by a logged in merchant and redirects to the edit user page if the user does not have a merchant name" do
        user = User.create(
          uid: 357,
          email: "supercoolemail@email.com",
          provider: "github",
          username: "cool_vender" 
        )
        perform_login(user)
  
        expect {
          post products_path, params: product_hash
        }.must_differ "Product.count", 1
  
        must_redirect_to edit_user_path
        assert_equal "You merchant name is currently empty. Please add a merchant name to add your fruit stand to the Merchants List.", flash[:message]
      end

      it "does not create a new product if given invalid params" do
        expect {
          post products_path, params: invalid_product_hash
        }.wont_differ "Product.count"

        must_respond_with :success
        assert_equal "Something went wrong! Product was not added.", flash[:error]
      end
    end

    describe "edit action" do
      it "gives back a successful response if a merchant is logged in" do
        product = products(:lemon_shirt)

        get edit_product_path(product.id)

        must_respond_with :success
      end

      it "redirects to the root path if given a product that does not exist" do
        product_id = -1

        get edit_product_path(product_id)

        must_redirect_to root_path
      end
    end

    describe "update action" do
      it "updates an existing product successfully by a logged in merchant and redirects to the current user path" do
        existing_product = products(:lemon_shirt)
    
        expect {
          patch product_path(existing_product.id), params: update_product_hash
        }.wont_differ "Product.count"
    
        product = Product.find_by(id: existing_product.id)
    
        expect(product.name).must_equal update_product_hash[:product][:name]
        expect(product.price).must_equal update_product_hash[:product][:price]
        expect(product.stock).must_equal update_product_hash[:product][:stock]
        expect(product.img_url).must_equal update_product_hash[:product][:img_url]
        expect(product.description).must_equal update_product_hash[:product][:description]
        expect(product.category_ids.first).must_equal update_product_hash[:product][:category_ids].first
    
        must_redirect_to current_user_path
      end

      it "does not update an existing product if given invalid params and redirects to the current user path" do
        product = products(:lemon_shirt)

        expect {
          patch product_path(product.id), params: invalid_product_hash
        }.wont_differ "Product.count"

        product_after = Product.find_by(id: product.id)

        must_redirect_to current_user_path
        expect(product_after.name).wont_equal invalid_product_hash[:product][:name]
        expect(product_after.price).wont_equal invalid_product_hash[:product][:price]
        expect(product_after.stock).wont_equal invalid_product_hash[:product][:stock]
        expect(product_after.img_url).wont_equal invalid_product_hash[:product][:img_url]
        expect(product_after.description).wont_equal invalid_product_hash[:product][:description]
        assert_equal "Something went wrong! Product can not be edited.", flash[:error]
      end
    end

    describe "destroy action" do
      it "successfully deletes an existing product by this merchant and then redirects to home page" do
        product = products(:lemon_shirt)
    
        expect {
          delete product_path(product.id) 
        }.must_differ "Product.count", -1
    
        must_redirect_to root_path
      end

      it "won't delete an existing product by other merchants and then redirects to home page" do
        logout_path
        user = users(:betsy)
        perform_login(user)
        product = products(:lemon_shirt)
    
        expect {
          delete product_path(product.id)
        }.wont_differ "Product.count"
    
        must_redirect_to root_path
      end
      
      it "redirects to products index page and deletes no products if no products exist" do
        user = users(:betsy)
        perform_login(user)
    
        expect {
          delete product_path(-1000)
        }.wont_differ "Product.count"
    
        must_redirect_to root_path
      end

      it "redirects to products index page and deletes no products if deleting a product with an id that has already been deleted" do
        product = products(:lemon_shirt)
        delete_id = product.id
        product.destroy
  
        expect {
          delete product_path(delete_id)
        }.wont_differ "Product.count"
  
        must_redirect_to root_path
      end
    end
  end
end
