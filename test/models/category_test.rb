require "test_helper"

describe Category do
  describe 'relations' do
    it 'has_many products' do
      expect(Category.new).must_respond_to :products
    end
  end
end
