require "test_helper"

describe Product do
  describe "validations" do
    it "must have a retired" do
      order1.retired = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :retired
      expect(order1.errors.messages[:retired]).must_equal ["is not included in the list"]
    end
  end
end
