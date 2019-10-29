require "test_helper"

describe Review do
  before do
    @review = reviews(:good_review)
  end

  it "can be instantiated" do
    assert(@review.valid?)
  end

  it "will have the required fields" do
    [:rating, :description, :user_id, :product_id].each do |field|
      expect(@review).must_respond_to field
    end
  end

  describe "relationships" do
    it 'can have a user' do
      expect(@review.user).must_equal users(:gretchen)
    end
    it 'can have a product' do
      expect(@review.product).must_equal products(:lemon_shirt)
    end
  end

  describe "validations" do

    describe 'rating' do
      it "must have a rating" do
        assert(@review.valid?)
        @review.rating = nil

        refute(@review.valid?)
      end

      it "rating must be an integer" do
        assert(@review.valid?)
        @review.rating = 1.5
        
        refute(@review.valid?)
      end
    
      it 'rating must be > 1' do
        assert(@review.valid?)
        @review.rating = -1
        
        refute(@review.valid?)
      end

      it 'rating must be < 6' do
        assert(@review.valid?)
        @review.rating = 10
        
        refute(@review.valid?)
      end
    end
  
    describe 'description' do
      it "must have a description" do
        assert(@review.valid?)
        @review.description = nil

        refute(@review.valid?)
      end

      it "description must be less than 350 char" do
        assert(@review.valid?)
        @review.description = (1..351).to_a.join('')

        refute(@review.valid?)
      end
    end

    describe 'user_id' do
      it "must have a user_id" do
        assert(@review.valid?)
        @review.user_id = nil

        refute(@review.valid?)
      end

      it "user_id must be unique in scope of product_id" do
        assert(@review.valid?)
        user = @review.user
        product = @review.product
        invalid_review = Review.create(rating: 2, description: "desc", product_id: product.id, user_id: user.id)
        refute(invalid_review.valid?)

        different_product = products(:strawberry_shoes)
        valid_review = Review.create(rating: 2, description: "desc", product_id: different_product.id, user_id: user.id)
        assert(valid_review.valid?)
      end
    end
    
    it "must have a product_id" do
        assert(@review.valid?)
        @review.product_id = nil

        refute(@review.valid?)
    end
  end
end