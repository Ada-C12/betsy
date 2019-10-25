require "test_helper"

describe ReviewsController do
  describe "new" do
    let(:product) { products(:product1) }
    it "responds with success" do 
      get new_product_review_path(product.id) 
      must_respond_with :success
    end 
  end
  describe "create" do
    let(:product) { products(:product1) }
    it " it creates a new review with valid information" do
      review_hash = {
        review: {
          rating: 5,
        },
      }

      expect {
        post product_reviews_path(product.id), params: review_hash
      }.must_differ "Review.count", 1
      must_redirect_to product_path(product.id)
    end
    it "if product id is invalid doesn't create review" do
      review_hash = {
        review: {
          rating: 5,
        },
      }

      expect {
        post product_reviews_path(-1), params: review_hash
      }.must_differ "Review.count", 0

      must_respond_with :not_found

    end
 
  end
end
