require "test_helper"

describe ProductsController do
  describe "index action" do
    it "gives back a successful response when provided no params" do
      get products_path
      must_respond_with :success
    end
    
    it "gives back a successful response when provided user_id" do
      user = users(:ada)
      get user_path(user)
      must_respond_with :success
    end

    it "returns 404 response when no user found" do
      get user_path(-1)
      must_respond_with :not_found
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
    it "gives back a successful response if a merchant logged in" do
      user = users(:ada)
      perform_login(user)
      get new_product_path
      must_respond_with :success
    end

    it "redirects user to root path if no merchant logged in" do
      get new_product_path
      must_redirect_to root_path
    end
  end

  describe "create action" do
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

    it "creates a new product successfully with valid data by a logged in merchant and redirects to the product page if the user has a merchant name" do
      user = users(:ada)
      perform_login(user)

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

    it "cannot create a new product if no merchant logged in, and redirects the user to root path" do
      user = users(:ada)

      expect {
        post products_path, params: product_hash
      }.must_differ "Product.count", 0

      must_redirect_to root_path
    end
  end

  describe "edit action" do
    it "gives back a successful response if a merchant logged in" do
      user = users(:ada)
      perform_login(user)
      product = products(:lemon_shirt)
      get edit_product_path(product.id)
      must_respond_with :success
    end

    it "redirects user to root path if no merchant logged in" do
      product = products(:lemon_shirt)
      get edit_product_path(product.id)
      must_redirect_to root_path
    end
  end

  describe "update action" do
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

    it "updates an existing product successfully by a logged in merchant and redirects the product show page" do
      user = users(:ada)
      perform_login(user)
      existing_product = products(:lemon_shirt)

      expect {
        patch product_path(existing_product.id), params: update_product_hash
      }.must_differ "Product.count", 0

      product = Product.find_by(id: existing_product.id)

      expect(product.name).must_equal update_product_hash[:product][:name]
      expect(product.price).must_equal update_product_hash[:product][:price]
      expect(product.stock).must_equal update_product_hash[:product][:stock]
      expect(product.img_url).must_equal update_product_hash[:product][:img_url]
      expect(product.description).must_equal update_product_hash[:product][:description]
      expect(product.category_ids.first).must_equal update_product_hash[:product][:category_ids].first

      must_redirect_to product_path(product.id)
    end

    it "cannot update a product if no merchant logged in, and redirects the user to the product page" do
      existing_product = products(:lemon_shirt)

      expect {
        patch product_path(existing_product.id), params: update_product_hash
      }.must_differ "Product.count", 0

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
end
