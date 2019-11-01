require "test_helper"

describe Product do
  describe 'relations' do
    before do
      @product = Product.new
    end
    
    it 'has_many order_items' do
      expect(@product).must_respond_to :order_items
    end

    it 'has_many categories' do
      expect(@product).must_respond_to :categories
    end
  
    it 'has_many reviews' do
      expect(@product).must_respond_to :reviews
    end
    
    it 'has_many reviews' do
      expect(@product).must_respond_to :reviews
  end
end 
  # still working on the test.

  describe 'validation' do
    # Product must belong to a User
    # product Name must be present
    # product Name must be unique
    # product Price must be present
    # product Price must be greater than 0
    it "requires a product name" do
    end

    it "requires a product name" do
    end

    it 'invalid without username' do
    end
  
    it 'invalid without email' do
    end
    
    it "requires a unique username" do
    end
  end
end
