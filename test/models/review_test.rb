require "test_helper"

describe Review do
  describe "validations" do
    before do
      # Arrange
      @review = Review.new(rating: 3, text: "text", product: Product.first)
    end

    it "is valid when all fields are present" do
      result = @review.valid?
      expect(result).must_equal true
    end

    it "is invalid without a product" do
      @review.product_id = nil

      expect(@review.valid?).must_equal false
      expect(@review.errors.messages[:product]).must_include "must exist"
    end

    it "is invalid without rating" do
      @review.rating = nil
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages).must_include :rating

      @review.rating = "kjfdk"

      expect(@review.valid?).must_equal false
      expect(@review.errors.messages).must_include :rating
    end

    it "is invalid when rating is not between 1 and 5" do
      @review.rating = 0
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages[:rating]).must_include "must be greater than 0"
      @review.rating = 6
      expect(@review.valid?).must_equal false
      expect(@review.errors.messages[:rating]).must_include "must be less than or equal to 5"
    end
  end

  describe "relations" do
    it "has a product" do
      review = Review.first
      product = review.product
      expect(product).must_be_instance_of Product
    end
  end
end
