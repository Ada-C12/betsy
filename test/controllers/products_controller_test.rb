require "test_helper"

describe ProductsController do
  before do 
    @user = users(:u_1)
  end 

  describe "index" do 
    it "shows all products saved and page showed successfully" do
      get products_path
      must_respond_with :success
    end
    
    it "even if there are no products saved but index succesfully shows" do
      Review.destroy_all
      OrderItem.destroy_all
      Product.destroy_all
      get products_path
      must_respond_with :success
    end
  end 
  
  describe "show" do 
    it "responds with success when showing a valid product" do
      product = products(:p_1)
      get product_path(product.id)
      must_respond_with :success
      
      expect(product.name).must_equal "ADULT RED FEZ HAT"
      expect(product.price).must_equal 20000
    end
    
    it "responds with 404 with an invalid product id" do
      get product_path(777)
      must_respond_with :not_found
    end
  end 

  describe "new" do
    it "responds with success" do
      perform_login(@user)
      get new_product_path
      must_respond_with :success
    end
  end 

  describe "create" do 
    it "saves new product and redirects" do
      perform_login(@user)
    
      product_hash = { product: { stock: 100, name: "Abu Jacket", description: "If the monkey wore it, I can wear it.", photo_url: "https://cdn-ssl.s7.disneystore.com/is/image/DisneyShopping/2845055508425", price: 50000, user_id: users(:u_1).id }}

      expect { post products_path, params: product_hash }.must_differ 'Product.count', 1
    
      # must_redirect_to product_path(Product.find_by(name: product_hash[:product][:name]))
      must_redirect_to dashboard_path(item: 'products')
    end

    # it "renders if product was not saved" do 
    # end 
  end 
    

  describe "edit" do 
    it "brings up edit form with rendered information" do 
      perform_login(@user)
      get edit_product_path(id: products(:p_1).id)
      must_respond_with :success
    end 

    it "will send to not_found for invalid product_id" do
      perform_login(@user)
      get edit_product_path(id: -666)
      must_respond_with :not_found
    end

    it "will not send merchant to for another merchant's product" do
      perform_login(@user)
      get edit_product_path(id: products(:p_3).id)
      must_redirect_to product_path(products(:p_3).id)
    end
  end 

  describe "update" do 
    it "saves updated information to existing product, redirects, and doesn't change product count" do 
      perform_login(@user)

      updated_product_data = { product: { name: "Golden Scarab Beetle Mirrors", price: 700 } }
  
      expect { patch product_path(products(:p_1).id), params: updated_product_data }.must_differ 'Product.count', 0
  
      patch product_path(products(:p_1).id), params: updated_product_data
      updated_product = Product.find_by(id: products(:p_1).id)
      
      expect(updated_product.name).must_equal updated_product_data[:product][:name]
      expect(updated_product.price).must_equal updated_product_data[:product][:price]
      
      # must_redirect_to product_path(products(:p_1).id)
      must_redirect_to dashboard_path(item: 'products')
    end 

    it "does not allow merchant to edit another merchant's product " do 
      perform_login(@user)

      updated_product_data = { product: { name: "Golden Scarab Beetle Mirrors", price: 700 } }
  
      expect { patch product_path(products(:p_2).id), params: updated_product_data }.must_differ 'Product.count', 0
  
      patch product_path(products(:p_2).id), params: updated_product_data
      updated_product = Product.find_by(id: products(:p_2).id)
      
      expect(updated_product.name).must_equal "Aladdin Golden Scarab Beetle Mirrors"
      
      must_redirect_to product_path(products(:p_2).id)
    end 

    it "redirects to not_found if product id does not exist" do 
      perform_login(@user)

      patch product_path(-777), params: { product: { price: 700} }
      must_respond_with :not_found
    end 
  end 

  describe "review" do 
    it "saves anonymous review and redirects" do
    #TEST FAILING BECAUSE THERE IS NO USER FIXTURE WITH ID = 0. CAN MAKE THIS TEST PASS BY ADDING SUCH USER BUT YML DECIDED TO BREAK THE OTHER TESTS IF WE DID THAT
      new_review = { rating: 4, user_review: "Best thing ever" }
      
      expect { 
        post review_product_path(products(:p_3).id), params: new_review 
      }.must_differ "Review.count", 1
      
      post review_product_path(products(:p_3).id), params: new_review

      expect(Review.last.rating).must_equal 4
      expect(Review.last.user_review).must_equal "Best thing ever"
      expect(Review.last.user_id).must_equal 0

      must_redirect_to product_path(products(:p_3).id)
    end 

    it "saves merchant review and redirects" do 
      perform_login(@user)

      new_review =  { rating: 4, user_review: "Best thing ever" }
    
      expect { post review_product_path(products(:p_3).id), params: new_review }.must_differ "Review.count", 1
      
      post review_product_path(products(:p_3).id), params: new_review
      
      expect(Review.last.rating).must_equal 4
      expect(Review.last.user_review).must_equal "Best thing ever"
      
      expect(User.find_by(id: Review.last.user_id).username).must_equal @user.username

      must_redirect_to product_path(products(:p_3).id)
    end 

    it "doesn't allow merchant to review own product and redirects" do 
      perform_login(@user)

      new_review =  { rating: 4, user_review: "Best thing ever" }
      # binding.pry
      expect { post review_product_path(products(:p_1).id), params: new_review }.must_differ "Review.count", 0

      must_redirect_to product_path(products(:p_1).id)
    end 
  end
end
