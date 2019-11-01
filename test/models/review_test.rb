require "test_helper"

describe Review do
  before do
    @review = reviews(:good_review)
  end
  
  it "can be instantiated" do
    assert(@review.valid?)
  end
  
  it "will have the required fields" do
    [:rating, :title, :description, :user_id, :product_id].each do |field|
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
    
    describe 'title' do
      it "must have a title" do
        assert(@review.valid?)
        @review.title = nil
        
        refute(@review.valid?)
      end
      
      it "title must be less than 150 char" do
        assert(@review.valid?)
        @review.title = (1..151).to_a.join('')
        
        refute(@review.valid?)
      end
    end
    
    describe 'product id' do
      it "must have a product_id" do
        assert(@review.valid?)
        @review.product_id = nil
        
        refute(@review.valid?)
      end
    end
  end
  
  describe "custom methods" do 
    describe "rating sentiment" do 
      it "returns nil if rating number is not valid" do 
        rating = 10000
        result = Review.rating_sentiment(rating)
        expect(result).must_be_nil
      end
      
      it "returns negavie if rating number is not valid" do 
        rating = 1
        result = Review.rating_sentiment(rating)
        expect(result).must_equal 'negative'
      end
      
      it "returns nil if rating number is not valid" do 
        rating = 5
        result = Review.rating_sentiment(rating)
        expect(result).must_equal 'positive'
      end
      
      it "returns nil if rating number is not valid" do 
        rating = 3
        result = Review.rating_sentiment(rating)
        expect(result).must_equal 'neutral'
      end
    end
  end
end