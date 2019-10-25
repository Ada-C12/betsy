require "test_helper"

describe Product do
  describe "validations" do
    it "must have a retired" do
      is_invalid = products(:product1)
      is_invalid.retired = nil
      
      expect(is_invalid.valid?).must_equal false
      expect(is_invalid.errors.messages).must_include :retired
      expect(is_invalid.errors.messages[:retired]).must_equal ["is not included in the list"]
    end
  end
end
