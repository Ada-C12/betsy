require "test_helper"

describe Review do
  describe 'relations' do
    it 'has a product' do
      expect(Review.new).must_respond_to :product
    end

    it 'has a user' do
      expect(Review.new).must_respond_to :user
    end
  end
end
