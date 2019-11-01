require "test_helper"

describe ReviewsController do
  let(:lemon_shirt) {
      products(:lemon_shirt)
    }
    let(:betsy) {
      users(:betsy)
    }
    
    let(:review_hash) {
      {
        review: {
          rating: 2,
          title: "Review Title",
          description: "description of a new product",
          user_id: betsy.id,
          product_id: lemon_shirt.id,
        }
      }
    }

    let(:invalid_review_hash) {
      {
        review: {
          rating: 10,
          title: 1,
          description: "",
          user_id: -1,
          product_id: lemon_shirt.id,
        }
      }
    }
  describe "guest user" do
    describe "create action" do
      it "creates a new review successfully with valid data, and redirects the user to the product page" do
        expect {
          post reviews_path, params: review_hash
        }.must_differ "Review.count", 1

        must_redirect_to product_path(lemon_shirt.id)
      end

      it "does not create new review when passed invalid data, and redirects user to the product page" do
        expect {
          post reviews_path, params: invalid_review_hash
        }.must_differ "Review.count", 0

        must_redirect_to product_path(lemon_shirt.id)
      end
    end

    describe 'destroy action' do
      it 'does not destroy a review and redirects to the root path if the user is not logged in' do
        review = Review.last
        
        expect {
          delete review_path(review.id) 
        }.wont_differ "Review.count"
        
        must_redirect_to root_path
      end
    end
  end
  
  describe "logged in user" do
    before do
      @user = users(:betsy)
      perform_login(@user)
    end
    
    describe "create action" do
      it "does not create a review if the User tries to review their own product and redirects to the product path" do
        product = products(:orange_costume)

        b_review_hash = {
          review: {
            rating: 2,
            title: "Review Title",
            description: "This product is totally worth $100!",
            user_id: betsy.id,
            product_id: product.id,
          }
        }

        expect {
          post reviews_path, params: b_review_hash
        }.wont_differ "Review.count"

        must_redirect_to product_path(product.id)
        assert_equal "You can't review your own product!", flash[:error]
      end
      
      it "does not create a review if the User tries to review the same product twice and redirects to the product path" do
        post reviews_path, params: review_hash

        expect {
          post reviews_path, params: review_hash
        }.wont_differ "Review.count"

        must_redirect_to product_path(lemon_shirt.id)
        assert_equal "You can't review a product more than once!", flash[:error]
      end
    end
    
    describe "destroy action" do
      it 'destroys a review successfully if belongs to current user, and redirects to reviews product page' do
        post reviews_path, params: review_hash
        review = @user.reviews.first
        product = review.product
        
        expect {
          delete review_path(review.id) 
        }.must_differ "Review.count", -1
        
        must_redirect_to product_path(product.id)
      end
      it 'will not destroy a review if product does not belong to current user, and redirects to reviews product page' do
        post reviews_path, params: review_hash
        review = @user.reviews.first
        product = review.product
        
        other_user = users(:ada)
        perform_login(other_user)
      
        expect {
          delete review_path(review.id) 
        }.must_differ "Review.count", 0
      
        must_redirect_to product_path(product.id)
      end
      
      it 'will not destroy a review if review doesnt exist, and redirects to root path' do
        post reviews_path, params: review_hash
        review = @user.reviews.first
        product = review.product
      
        expect {
          delete review_path(-1) 
        }.must_differ "Review.count", 0
      
        must_redirect_to root_path
      end
    end
  end
end
