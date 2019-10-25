require "test_helper"

describe Product do
  describe "relations" do
    let (:product) {products(:baguette)}
    
    it "has one or many categories" do
      product.must_respond_to :categories
      product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end
    
    it "can have a single merchant" do
      product.must_respond_to :merchant_id
      product.merchant.must_be_kind_of Merchant
    end
  end
  
  describe "custom methods" do 
    describe "retire method" do
      before do
        @product = Product.create(name:"twice-baked almond croissant", description:"Almond Croissants are day old croissants that are filled and topped with almond paste and sliced almonds", price: 1.99, photo_URL: "https://unsplash.com/photos/5msGxboneMA", stock: 11, merchant_id: 5)
      end
      it "toggled self.active from true to false" do
        @product.active = true
        @product.save
        @product.retire
        expect(@product.active).must_equal false
      end
      it "toggled self.active from false to true" do
        @product.active = false
        @product.save 
        @product.retire
        expect(@product.active).must_equal true
      end
    end
  end 
  
end

