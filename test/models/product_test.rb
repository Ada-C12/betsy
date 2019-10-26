require "test_helper"

describe Product do
  describe "validations" do

    it "must have a name, price, stock, wizard, categories and retired information" do
      is_valid = products(:product1).valid?
      assert(is_valid)
    end

    it "is invalid if there is no name" do
      is_invalid = products(:product1)
      is_invalid.name = nil

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :name
      expect(is_invalid.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "is invalid if there is no price" do
      is_invalid = products(:product1)
      is_invalid.price = nil

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :price
      expect(is_invalid.errors.messages[:price]).must_equal ["can't be blank", "is not a number"]

    end

    it "is invalid if price is not an integer" do
      is_invalid = products(:product1)
      is_invalid.price = "a"
  
      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :price
      expect(is_invalid.errors.messages[:price]).must_equal ["is not a number"]

    end


    it "is invalid if there is no stock" do
      is_invalid = products(:product1)
      is_invalid.stock = nil

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :stock
      expect(is_invalid.errors.messages[:stock]).must_equal ["can't be blank", "is not a number"]

    end

    it "is invalid if stock is not an integer" do
      is_invalid = products(:product1)
      is_invalid.stock = "a"
  
      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :stock
      expect(is_invalid.errors.messages[:stock]).must_equal ["is not a number"]

    end

    it "is invalid if there is no wizard" do
        is_invalid = products(:product1)
        is_invalid.wizard = nil
  
        refute(is_invalid.valid?)
        expect(is_invalid.errors.messages).must_include :wizard
        expect(is_invalid.errors.messages[:wizard]).must_equal ["must exist", "can't be blank"]
  
    end


    it "must have a retired" do
      is_invalid = products(:product1)
      is_invalid.retired = nil
      
      expect(is_invalid.valid?).must_equal false
      expect(is_invalid.errors.messages).must_include :retired
      expect(is_invalid.errors.messages[:retired]).must_equal ["is not included in the list"]
    end
  end
end
