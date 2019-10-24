require "test_helper"

describe ProductsController do
  describe "index action" do
    it "gives back a successful response" do
      get products_path
      must_respond_with :success
    end
  end

  describe "show action" do
    it "responds with a success when id given exists" do
      product = products(:lemon_shirt)
      get product_path(product.id)
      must_respond_with :success
    end

    it "responds with a not_found when id given does not exist" do
      get product_path("500")
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
          quantity: 20,
          img_url: "new_img.com",
          user_id: users(:ada).id,
          categories: [categories(:strawberry)],
          description: "description of a new product"
        }
      }
    }

    it "creates a new product successfully with valid data by a logged in merchant, and redirects the user to the product page" do
      user = users(:ada)
      perform_login(user)

      expect {
        post products_path, params: product_hash
      }.must_differ "Product.count", 1

      must_redirect_to product_path(Product.find_by(name: "new product"))
    end

    it "cannot creates a new product if no merchant logged in, and redirects the user to root path" do
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
          quantity: 20,
          img_url: "new_img.com",
          user_id: users(:ada).id,
          categories: [categories(:strawberry)],
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

      find_product = Product.find_by(id: existing_product.id)

      expect(find_product.name).must_equal update_product_hash[:product][:name]
      expect(find_product.price).must_equal update_product_hash[:product][:price]
      expect(find_product.quantity).must_equal update_product_hash[:product][:quantity]
      expect(find_product.img_url).must_equal update_product_hash[:product][:img_url]
      expect(find_product.user.id).must_equal update_product_hash[:product][:user_id]
      expect(find_product.description).must_equal update_product_hash[:product][:description]
      # expect(find_product.categories.first.category).must_equal update_product_hash[:product][:categories].first.category

      must_redirect_to product_path(Product.find_by(name: "lemon product"))
    end

    it "cannot update a product if no merchant logged in, and redirects the user to the product page" do
      existing_product = products(:lemon_shirt)

      expect {
        patch product_path(existing_product.id), params: update_product_hash
      }.must_differ "Product.count", 0

      find_product = Product.find_by(id: existing_product.id)

      expect(find_product.name).must_equal existing_product.name
      expect(find_product.price).must_equal existing_product.price
      expect(find_product.quantity).must_equal existing_product.quantity
      expect(find_product.img_url).must_equal existing_product.img_url
      expect(find_product.user.id).must_equal existing_product.user_id
      expect(find_product.description).must_equal existing_product.description
      # expect(find_product.categories.first.category).must_equal existing_product.categories.first.category

      must_redirect_to root_path
    end
  end

  describe "destroy action" do
    it "successfully deletes an existing product by this merchant and then redirects to home page" do
      user = users(:ada)
      perform_login(user)
      product = products(:lemon_shirt)

      expect {
        delete product_path(product.id) 
      }.must_differ "Product.count", -1

      must_redirect_to root_path
    end

    it "won't delete an existing product by other merchants and then redirects to home page" do
      user = users(:betsy)
      perform_login(user)
      product = products(:lemon_shirt)

      expect {
        delete product_path(product.id)
      }.must_differ "Product.count", 0

      must_redirect_to root_path
    end

    it "redirects to products index page and deletes no products if no products exist" do
      user = users(:betsy)
      perform_login(user)

      expect {
        delete product_path(-1000)
      }.must_differ "Product.count", 0

      must_redirect_to root_path
    end

    it "redirects to products index page and deletes no products if no merchant is logged in" do
      product = products(:lemon_shirt)

      expect {
        delete product_path(product.id)
      }.must_differ "Product.count", 0

      must_redirect_to root_path
    end

    it "redirects to products index page and deletes no products if deleting a product with an id that has already been deleted" do
      user = users(:ada)
      perform_login(user)
      product = products(:lemon_shirt)
      delete_id = product.id
      product.destroy

      expect {
        delete product_path(delete_id)
      }.must_differ "Product.count", 0

      must_redirect_to root_path
    end
  end
end
