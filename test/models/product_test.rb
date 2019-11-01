require "test_helper"

describe Product do
  describe "validations" do
    it "can be instantiated" do
      user = User.first
      
      product = Product.create(name: "product", price: 599.99, qty: 5, user_id: user.id)
      
      expect(product.valid?).must_equal true
    end
    
    it "does not create a product if name is not present" do
      user = User.first
      
      invalid_product = Product.create(name: nil, price: 599.99, qty: 5,  user_id: user.id)
      expect(invalid_product.valid?).must_equal false
    end
    
    it "does not create a product if name is not unique" do
      user = User.first
      
      product_1 = Product.create(name: "this is a product", price: 599.99, qty: 5, user_id: user.id)
      product_2 = Product.create(name: "this is a product", qty: 5, price: 599.99, user_id: user.id)
      
      expect(product_2.valid?).must_equal false
    end
    
    it "does not create a product if price is not present" do
      user = User.first
      
      invalid_product = Product.create(name: "this is a product", price: nil, qty: 5, user_id: user.id)
      expect(invalid_product.valid?).must_equal false
    end
    
    it "does not create a product if price is not a float greater than 0" do
      user = User.first
      
      invalid_product = Product.create(name: nil, price: -58.54, qty: 5, user_id: user.id)
      expect(invalid_product.valid?).must_equal false
    end
    
    it "does not create a product if price is not a float" do
      user = User.first
      
      invalid_product = Product.create(name: nil, price: 58, qty: 5, user_id: user.id)
      expect(invalid_product.valid?).must_equal false
    end    
    
    it "does not create a product if qty is not an integer" do
      user = User.first
      
      invalid_product = Product.create(name: nil, price: 58, qty: 5.5,  user_id: user.id)
      expect(invalid_product.valid?).must_equal false
    end  
  end
  
  describe "relationships" do
    it "has a user" do
      user = User.first
      
      product = Product.create(name: "product", price: 599.99, qty: 5, user_id: user.id)
      
      expect(product).must_respond_to :user
      expect(product.user).must_be_kind_of User
    end
    
    it "has a category" do
      product = products(:product_1)
      
      expect(product).must_respond_to :categories
      product.categories.each do |category|
        expect(category).must_be_kind_of Category
      end
    end
    
    it "contains many order items" do
      product = products(:product_1)
      
      expect(product.order_items.count).must_equal 3
      expect(product).must_respond_to :order_items
      product.order_items.each do |order_item|
        expect(order_item).must_be_kind_of OrderItem
      end
    end
    
    it "can contain many reviews" do
      product = products(:product_1)
      
      expect(product.reviews.count).must_equal 2
      expect(product).must_respond_to :reviews
      product.reviews.each do |review|
        expect(review).must_be_kind_of Review
      end
    end
  end
  
  describe "custom methods" do 
    
    it "calculate the average rating of a product with reviews" do
      product = products(:product_1)
      
      expect(product.avg_rating).must_equal 3
    end
    
    it "returns string for the average rating of a product without reviews" do
      product = products(:product_3)
      
      expect(product.avg_rating).must_equal "There aren't any ratings for this product yet."
    end
    
    it "finds the highest rated product - spotlight" do
      spotlight = Product.spotlight
      
      expect(spotlight).must_be_kind_of Product
    end
    
    it "finds newly added products" do
      product = Product.top_rated
      
      expect(product).must_be_kind_of Product
      expect(product.name).must_equal products(:product_1).name
    end
    
  end
  
  it "finds newly added products" do
    products = Product.newly_added
    
    products.each do |product|
      expect(product).must_be_kind_of Product
    end
  end
  
end
