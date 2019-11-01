require "test_helper"

describe Review do
  describe "relationships" do
    it "belongs to a product" do
      new_review = Review.new(rating: 5)
      
      products(:sapporo).reviews << new_review
      
      updated_product = Product.find_by(id: products(:sapporo).id)
      
      expect(updated_product.reviews.count).must_equal 1
      expect(Review.last.product_id).must_equal updated_product.id
    end
  end
  
  describe "validations" do
    it "can create a valid review" do
      expect { Review.create(rating: 5, product: products(:sapporo)) }.must_change "Review.count", 1
    end
    
    it "cannot create a new review without a rating" do
      new_review = Review.new(text_review: "hello", product: products(:sapporo))
      
      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :rating
      expect(new_review.errors.messages[:rating]).must_include "can't be blank"
    end
    
    it "cannot create a non-numerical rating" do
      new_review = Review.new(rating: "abc", text_review: "hello", product: products(:sapporo))
      
      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :rating
      expect(new_review.errors.messages[:rating]).must_include "is not a number"
    end
    
    it "cannot create a rating with a float" do
      new_review = Review.new(rating: 5.0, text_review: "hello", product: products(:sapporo))
      
      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :rating
      expect(new_review.errors.messages[:rating]).must_include "must be an integer"
    end
    
    it "does not accept 0 as a rating" do
      new_review = Review.new(rating: 0, text_review: "hello", product: products(:sapporo))
      
      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :rating
      expect(new_review.errors.messages[:rating]).must_include "must be greater than 0"
    end
    
    it "does accept 1 as a rating" do
      new_review = Review.new(rating: 1, text_review: "hello", product: products(:sapporo))
      
      expect(new_review.valid?).must_equal true
    end
    
    it "does accept 5 as a rating" do
      new_review = Review.new(rating: 5, text_review: "hello", product: products(:sapporo))
      
      expect(new_review.valid?).must_equal true
    end
    
    it "does not accept 6 as a rating" do
      new_review = Review.new(rating: 6, text_review: "hello", product: products(:sapporo))
      
      expect(new_review.valid?).must_equal false
      expect(new_review.errors.messages).must_include :rating
      expect(new_review.errors.messages[:rating]).must_include "must be less than 6"
    end
  end
end
