require "test_helper"

describe Review do
  describe "validations" do
    it "must have rating" do
      is_valid = reviews(:review1).valid?
      assert(is_valid)
    end

    it "is invalid if there is no rating" do
      is_invalid = reviews(:review1)
      is_invalid.rating = nil

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :rating
      expect(is_invalid.errors.messages[:rating]).must_equal ["can't be blank", "is not a number"]
    end

    it "is invalid if rating is outside range 1 thru 5" do
      is_invalid = reviews(:review1)
      is_invalid.rating = 6

      refute(is_invalid.valid?)
    end

    it "is invalid if rating is not an integer" do
      is_invalid = reviews(:review1)
      is_invalid.rating = "a"
  
      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :rating
      expect(is_invalid.errors.messages[:rating]).must_equal ["is not a number"]

    end

  end

  describe "relationships" do
    it "can set the product through 'product'" do
      product = products(:product1)
      review = Review.new(rating: 4)

      review.product = product
      expect(review.product_id).must_equal product.id
    end

    it "can set the product through 'product'" do
      product = products(:product1)
      review = Review.new(rating: 4)

      review.product_id = product.id
      expect(review.product).must_equal product

    end


  end
end
