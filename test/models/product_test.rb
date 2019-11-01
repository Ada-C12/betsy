require "test_helper"
describe Product do
  let(:product1) { products(:product1) }
  let(:wizard1) { wizards(:wizard1) }
  let(:category1) { categories(:category1) }
  
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
    
    it "is invalid if stock is less than zero" do
      is_invalid = products(:product1)
      is_invalid.stock = -1
      
      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :stock
      expect(is_invalid.errors.messages[:stock]).must_equal ["must be greater than 0"]
      
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
  
  describe "custom methods" do
    describe "five_products" do
      it "returns 5 products" do
        Product.create(name: 'new-product-1', price_cents: 1500, description: 'obscure figure while traveling through the mist', stock: 10, wizard: wizard1, categories: [category1], photo_url: 'https://i.imgur.com/BCK4aAc.jpg', retired: false)
        Product.create(name: 'new-product-2', price_cents: 1500, description: 'obscure figure while traveling through the mist', stock: 10, wizard: wizard1, categories: [category1], photo_url: 'https://i.imgur.com/BCK4aAc.jpg', retired: false)
        Product.create(name: 'new-product-3', price_cents: 1500, description: 'obscure figure while traveling through the mist', stock: 10, wizard: wizard1, categories: [category1], photo_url: 'https://i.imgur.com/BCK4aAc.jpg', retired: false)
        
        expect(Product.all.length).must_equal 6
        
        expect(Product.five_products.length).must_equal 5
      end
    end
    
    describe "list_unretired" do
      it "only lists unretired products" do
        Product.list_unretired.each do |product|
          expect(product.retired).must_equal false
        end
      end

      it "only lists that wizards products when wizard argument is passed in" do
        Product.list_unretired(wizard1).each do |product|
          expect(product.wizard).must_equal wizard1
        end
      end
    end

    describe "make_retired_true" do
      it "can change retired attribute to true" do
        expect(product1.retired).must_equal false

        product1.make_retired_true

        expect(product1.retired).must_equal true
      end

      it "does not change retired attribute when already true" do
        product1.retired = true
        product1.save
        expect(product1.retired).must_equal true

        product1.make_retired_true

        expect(product1.retired).must_equal true
      end
    end

    describe "make_retired_false" do
      it "can change retired attribute to false" do
        product1.retired = true
        product1.save
        expect(product1.retired).must_equal true

        product1.make_retired_false

        expect(product1.retired).must_equal false
      end

      it "does not change retired attribute when already false" do
        expect(product1.retired).must_equal false

        product1.make_retired_false

        expect(product1.retired).must_equal false
      end
    end
  end
end
