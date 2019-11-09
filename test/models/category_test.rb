require "test_helper"

describe Category do
  describe "validations" do
    before do
      @category = Category.new(name: "yasms")
    end

    it "is valid when all fields are present and unique" do
      result = @category.valid?

      expect(result).must_equal true
    end

    it "is invalid without id" do
      @category.name = nil

      expect(@category.valid?).must_equal false
      expect(@category.errors.messages).must_include :name
    end

    it "is invalid if the name is not unique" do
      new_category = Category.new(name: "Flowers")
      new_category.save
      @category.name = new_category.name
      @category.save
      expect(@category.valid?).must_equal false
      expect(@category.errors.messages).must_include :name
    end
  end

  describe "relations" do
    it "has products" do
      category = Category.first
      products = category.products
      products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end
end

