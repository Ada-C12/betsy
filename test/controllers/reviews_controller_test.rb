require "test_helper"

describe ReviewsController do
  describe "new" do
    it "responds with success" do
      get new_product_review_path(product_id: Product.first.id)
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a valid review and redirects to product page" do
      valid_hash = {
        review: {
          rating: 5,
          product: products(:sapporo)
        },
      }
      
      expect {
        post product_reviews_path(product_id: products(:sapporo).id), params: valid_hash
      }.must_change "Review.count", 1
      
      new_review = Review.last
      
      expect(new_review.rating).must_equal 5
      expect(new_review.text_review).must_be_nil
      expect(new_review.product_id).must_equal products(:sapporo).id
      
      must_redirect_to product_path(id: products(:sapporo).id)
    end
    
    it "cannot create an invalid review and returns a bad_request status" do
      invalid_hash = {
        review: {
          text_review: "hello",
          product: products(:sapporo)
        },
      }
      
      expect {
        post product_reviews_path(product_id: products(:sapporo).id), params: invalid_hash
      }.wont_change "Review.count"
      
      must_respond_with :bad_request
    end
    
    it "responds with not_found for invalid product id" do
      valid_hash = {
        review: {
          rating: 5,
          product: products(:sapporo)
        },
      }
      
      expect {
        post product_reviews_path(product_id: -1), params: valid_hash
      }.wont_change "Review.count"
      
      must_respond_with :not_found
    end
    
    it "does not allow merchants to review their own products" do
      perform_login(merchants(:brad))
      
      expect(session[:merchant_id]).must_equal merchants(:brad).id
      
      valid_hash = {
        review: {
          rating: 5,
          product: products(:sapporo)
        },
      }
      
      expect {
        post product_reviews_path(product_id: products(:sapporo).id), params: valid_hash
      }.wont_change "Review.count"
      
      expect(flash[:result_text]).must_include "Users cannot review their own products!"
      
      must_redirect_to product_path(products(:sapporo))
    end
  end
end
