require "test_helper"
describe Product do
  let(:product1) { products(:product1) }
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
    
    it "is invalid if there is more than one of the same name in the same category" do
      is_invalid = Product.create(name: "mistcloak", categories: [categories(:category2)])
      
      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :name
      expect(is_invalid.errors.messages[:name]).must_equal ["has already been taken"]
    end
    
    it "is invalid if there is no price_cents" do
      is_invalid = products(:product1)
      is_invalid.price_cents = nil
      
      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :price_cents
      expect(is_invalid.errors.messages[:price_cents]).must_equal ["can't be blank", "is not a number"]
      
    end
    
    it "is invalid if price_cents is not an integer" do
      is_invalid = products(:product1)
      is_invalid.price_cents = "a"
      
      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :price_cents
      expect(is_invalid.errors.messages[:price_cents]).must_equal ["is not a number"]
      
    end
    
    it "is invalid if price_cents is not greater than 0" do
      is_invalid = products(:product1)
      is_invalid.price_cents = 0
      
      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :price_cents
      expect(is_invalid.errors.messages[:price_cents]).must_equal ["must be greater than 0"]
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
  
  describe "relationships" do
    it "can set wizard through 'wizard'" do
      wizard = wizards(:wizard1)
      products(:product1).wizard = wizard
      
      expect(products(:product1).wizard).must_equal wizard
      
    end
    
    it "can have many reviews" do
      valid_product = products(:product1)
      
      expect(valid_product.reviews.count).must_equal 1
      valid_product.reviews.each do |review|
        review.must_be_kind_of Review
      end
    end
    
    it "can have many order_items" do
      valid_product = products(:product1)
      
      expect(valid_product.order_items.count).must_equal 2
      valid_product.order_items.each do |order_item|
        order_item.must_be_kind_of OrderItem
      end
    end
    
    it "can have many categories" do
      valid_product = products(:product1)
      expect(valid_product.categories.count).must_equal 2
      valid_product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end
    
  end
end
