require "test_helper"

describe Product do
  let(:product1) { products(:product1) }
  describe "validations" do
    it "must have a retired" do
      is_invalid = product1
      is_invalid.retired = nil
      
      expect(is_invalid.valid?).must_equal false
      expect(is_invalid.errors.messages).must_include :retired
      expect(is_invalid.errors.messages[:retired]).must_equal ["is not included in the list"]
    end
  end
  describe "monetize price_cents" do
    it "stores a money object in .price with amount equal to price_cents in USD" do
      expect(product1.price).must_be_instance_of Money
      expect(product1.price.amount).must_equal product1.price_cents * 10**-2
      expect(product1.price.currency.id).must_equal :usd
    end
  end
end
