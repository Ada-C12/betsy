require "test_helper"

describe ReviewsController do
  
  let (:product) {
    products(:magician)
  }
  
  let (:review) {
    reviews(:one)
  }
  
  describe "create" do
    
    describe "while not logged in" do
      
      it "guest can create a review with valid data and is redirected to product page" do
        
        review_hash = {
          review: {
            rating: 2, 
            text: "Not very good at all",
            product_id: product.id,
          }
        }
        
        expect {
          post product_reviews_path(product.id), params: review_hash
        }.must_differ "Review.count", 1
        
        
        must_respond_with :redirect
        must_redirect_to  product_path(product.id)
        
      end
      
      it "review cannot be created with invalid data" do
        
        invalid_rating_hash = {
          review: {
            rating: 11, 
            text: "Really really awesome",
            product_id: product.id,
          }
        }
        
        invalid_id_hash = {
          review: {
            rating: 2, 
            text: "Not very good at all",
            product_id: -5,
          }
        }
        
        expect {
          post product_reviews_path(product.id), params: invalid_rating_hash
        }.wont_change "Review.count"
        
        assert_template :new
        
      end
      
    end
    
    describe "while logged in" do
      
      it "merchant can't add a review for their own product" do 
        
        # create a merchant
        merchant = Merchant.create(provider: "github", uid: 1789, username: "test_user", email: "test@user.com")
        
        # add a product for that merchant
        beard = Product.create(name: "Big beard", price: 10, stock: 11, description: "The perfect finishing touch for an Old Dog Winter, Santa Dog, or Dumbledog costume.", photo: nil, retire: false, merchant_id: merchant.id)
                
        # log the merchant in
        perform_login(merchant)
        
        # create params for merchant's review of product
        merchant_review = {
          review: {
            rating: 5, 
            text: "Just really great",
            product_id: beard.id,
          }
        }
        
        # try to post review -- review won't be saved
        expect {
          post product_reviews_path(beard.id), params: merchant_review
        }.wont_differ "Review.count"
        
        # must_redirect_to product_path
        must_respond_with :redirect
        must_redirect_to  product_path(beard.id)

        _(flash[:warning]).wont_be_nil
        
      end
      
    end
    
  end
  
  describe "new" do
    it "loads the review form" do
      
      get new_product_review_path(product.id)
      must_respond_with :success
    end
    
  end
  
end