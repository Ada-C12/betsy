require "test_helper"

describe Product do
  describe "relations" do
    it "has a list of categories" do
      product = products(:aloe)
      _(product).must_respond_to :categories
      product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end

    it "is included in the list of categories" do
      category = categories(:suc)
      product = products(:fern)
      _(category).must_respond_to :products
      category.products.each do |product|
        product.must_be_kind_of Product
      end
    end

    it "includes a list of order items" do
      product = products(:aloe)
      _(product).must_respond_to :order_items
      product.order_items.each do |item|
        item.must_be_kind_of OrderItem
      end
    end

    it "includes a list of reviews" do
      product = products(:fern)
      _(product).must_respond_to :reviews
      product.reviews.each do |review|
        review.must_be_kind_of Review
      end
    end

    it "belongs to a merchant" do
      product = products(:fern)
      merchant = product.merchant
      expect(merchant).must_be_kind_of Merchant
    end
  end

  describe "validations" do
    let (:new_product) {
      Product.new(name: "Morning glory", price: 9, merchant: merchants(:bob))
    }
    it "is valid when all required fields are present" do
      result = new_product.valid?
      expect(result).must_equal true
    end

    it "is invalid when product has no name" do
      product = Product.new(price: 3)
      _(product.valid?).must_equal false
      _(product.errors.messages).must_include :name
    end

    it "requires the name to be unique" do
      product1 = Product.create(name: products(:aloe), price: 8, merchant: merchants(:bob))
      product2 = Product.new(name: products(:aloe), price: 8, merchant: merchants(:bob))
      _(product2.valid?).must_equal false
      _(product2.errors.messages).must_include :name
    end

    it "is invalid when product has no price" do
      another_product = Product.new(name: "cactus")
      _(another_product.valid?).must_equal false
      _(another_product.errors.messages).must_include :price
    end

    it "requires a price that is greater than 0" do
      prod = Product.new(name: "Carnation", price: 0, merchant: merchants(:bob))
      _(prod.valid?).must_equal false
      _(prod.errors.messages).must_include :price
    end
  end

  describe "custom methods" do
    it "returns the top products" do
      top_products = Product.top_products
      expect(top_products).must_be_kind_of Array
      _(top_products.length).must_equal 3
    end
  end
end
