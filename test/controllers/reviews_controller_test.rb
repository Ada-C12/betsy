require "test_helper"

describe ReviewsController do
  let(:product) {
    products(:product_1)
  }
  describe "new" do 
    it "can get the new review path" do
      get new_product_review_path(product.id)
      must_respond_with :success
    end
    
  end
  
  describe "create" do
    
    it "creates a new review with valid data" do      
      
      new_review = {rating: 4, review_text: "this sucked", product_id: product.id } 
      
      expect{ post product_reviews_path(product.id), params: new_review }.must_differ 'Review.count', 1
      
      must_respond_with :redirect
      must_redirect_to product_path(product.id)
      
    end
    
    it "will not create a review without a rating" do
      new_review = { review:  {rating: nil, review: "this sucked", product_id: product.id } }
      
      expect{ post product_reviews_path(product.id), params: new_review }.wont_change 'Review.count'
      
      must_respond_with :bad_request
      
    end 
    
    # it "renders bad_request and does not update the DB" do
    #   bad_product = { product:  {name: "", qty: 7, price: 149.99, description: "This product is new", status: "active"} }
    
    #   expect { post products_path, params: bad_product }.wont_change "Product.count"
    
    #   must_respond_with :redirect
    
    # end
    
  end
end
