require "test_helper"

describe Category do
  describe "validations" do
    it "can be valid" do
      is_valid = categories(:valid_category).valid?

      assert( is_valid )
    end

    it "is invalid if there is no name" do
      invalid_category = categories(:valid_category)
      invalid_category.name = ""

      is_valid = invalid_category.valid?

      refute( is_valid )
    end

    it "gives an error message if the name given is not unique" do
      invalid_category = categories(:valid_category2)
      invalid_category.name = "ExpensiveItems"

      is_valid = invalid_category.valid?

      refute( is_valid )
    end
  end

  describe "relationships" do
    it "can have many products" do
      category = categories(:valid_category)

      list_of_products = [products(:product_1), products(:product_2), products(:product_3)]

      list_of_products.each do |product|
        category.products << product
      end

      expect(category.products.count).must_equal 3
      category.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end

    it "returns 0 and does not break if there are no products in the category" do
      category = categories(:valid_category)

      list_of_products = []

      list_of_products.each do |product|
        category.products << product
      end

      expect(category.products.count).must_equal 0
    end
  end

  describe "custom methods" do
    describe "num_products_in_category method" do
      it "can return the correct count" do
        category = categories(:valid_category)

        list_of_products = [products(:product_1), products(:product_2), products(:product_3)]

        list_of_products.each do |product|
          category.products << product
        end

        expect(category.num_products_in_category).must_equal 3
      end
    end
  end
end
