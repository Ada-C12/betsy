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
          description: "",
          user_id: -1,
          product_id: -1,
        }
      }
    }

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

      must_redirect_to root_path
    end
  end

  describe 'destroy action' do
    it 'destroys a review successfully if belongs to current user, and redirects to reviews product page' do
      user = users(:betsy)
      perform_login(user)
      post reviews_path, params: review_hash
      review = user.reviews.first
      product = review.product

      expect {
        delete review_path(review.id) 
      }.must_differ "Review.count", -1

      must_redirect_to product_path(product.id)
    end
    it 'will not destroy a review if product does not belong to current user, and redirects to reviews product page' do
      user = users(:betsy)
      post reviews_path, params: review_hash
      review = user.reviews.first
      product = review.product
      
      other_user = users(:ada)
      perform_login(other_user)

      expect {
        delete review_path(review.id) 
      }.must_differ "Review.count", 0

      must_redirect_to product_path(product.id)
    end

    it 'will not destroy a review if review doesnt exist, and redirects to root path' do
      user = users(:betsy)
      perform_login(user)
      post reviews_path, params: review_hash
      review = user.reviews.first
      product = review.product

      expect {
        delete review_path(-1) 
      }.must_differ "Review.count", 0

      must_redirect_to root_path
    end
  end


end
