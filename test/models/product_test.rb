require "test_helper"

describe Product do
  describe "relationships" do 
    it "has a merchant" do 
      batman = products(:batman)
      (batman.merchant).must_equal merchants(:mariya)
    end 
    
    it "can set a merchant through products" do 
      glasses = Product.new(name: "test glasses", price: 25.00, stock: 2)
      glasses.merchant = merchants(:mariya)
      (glasses.merchant).must_equal merchants(:mariya)
    end
  end
  
  describe "validations" do 
    it "has a name" do 
      batman = products(:batman)
      batman.name.must_equal "batman"
    end 
    
    it "has  a unique name" do 
      superman = Product.new(name: "batman", price: 25.00, stock: 2)
      superman.valid?.must_equal false
    end
    
    it "has a price" do 
      batman = products(:batman)
      batman.price.must_equal 5.99
    end
    
    it "does not accept non-numerical price value" do 
      superman = Product.new(name: "batman", price: "abc", stock: 2)      
      superman.valid?.must_equal false 
    end 
    
    it "has a price that is greater than 0" do 
      superman = Product.new(name: "batman", price: "abc", stock: -2)      
      superman.valid?.must_equal false 
    end
    
    it "has a stock amount" do 
      wonder_woman = Product.new(name: "wonder woman", price: 25.00, stock: 2)
      wonder_woman.stock.must_equal 2
    end
    
    it "does not accept negative values for stock amount" do
      wonder_woman = Product.new(name: "wonder woman", price: 25.00, stock: -2)
      wonder_woman.valid?.must_equal false
    end
  end
  
  describe "custom methods" do 
    describe "sort by name ascending" do
      it "sorts products alphabetically" do 
        

        product_1 = products(:batman)
        product_2 = products(:wizard)
        
        products_ascending = Product.sort_ascending

        # product_1 is first alphabetically, so it should be first on the list
    
        expect( products_ascending[0] ).must_equal product_1

        expect( products_ascending[-1] ).must_equal product_2

      end

      it "returns empty array if there are no products" do
        Product.destroy_all
        products_ascending = Product.sort_ascending
        
        expect( products_ascending.count ).must_equal 0
      end
    end

    it "calculates average rating" do 
      clown = products(:clown)
      review1 = Review.create(product_id: clown.id, rating: 4)
      review2 = Review.create(product_id: clown.id, rating: 5)

      # Act
      avg = clown.average_rating
      
      # Assert
      expect(avg).must_equal 4.5
    end

  end
end
