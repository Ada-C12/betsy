require "test_helper"

describe ReviewsController do
  let(:product) { products(:aloe) }
  describe "new" do
    it "can get the new form" do
      get new_product_review_path(product.id)

      must_respond_with :success
    end
  end
  describe "create" do
    it "creates a new review successfully with valid data" do
      review_hash = {
        review: {
          rating: 5,
          text: "It healed my wounds",
        },
      }
      expect {
        post product_reviews_path(product.id), params: review_hash
      }.must_differ "Review.count", 1

      must_redirect_to product_path(product.id)
    end
  end
end
