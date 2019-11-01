require "test_helper"

describe Category do
  describe "relationships" do 
    it "can retrieve products related to its category" do 
      # Arrange
      puppy = categories(:puppy)
      
      # Act - Assert
      expect(puppy.products.first).must_be_kind_of Product
      expect(puppy.products.first.name).must_equal "batman"
    end

    it "can add a product through its category" do 
      # Arrange
      cat = Category.new(name: "cat")
      
      # Act
      mice = Product.new(name: "mice", merchant_id: 1, stock: 3, price: 12.99, description: "abc", photo: nil, retire: false)
      cat.products << mice 
      
      
      # Assert
      expect(cat.products.first).must_be_kind_of Product
      expect(cat.products.first.name).must_equal "mice"
      
    end
  end
  
  describe "validations" do 
    it "has a name" do 
      # Arrange
      puppy = categories(:puppy)

      # Act
      result = puppy.valid?

      # Assert
      expect(result).must_equal true
      
    end

    it "is invalid without a name" do 
      # Arrange
      puppy = categories(:puppy)
      puppy.name = nil

      # Act
      result = puppy.valid?

      # Assert
      expect(result).must_equal false 
    end 

    it "has a unique category name" do 
      # Arrange
      puppy = categories(:puppy)
      cat = Category.create(name: "puppy")

      # Act
      result = cat.valid?

      # Assert
      expect(result).must_equal false

    end
  end
end
