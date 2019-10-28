require "test_helper"

describe Product do
  let(:new_product) {
    Product.new(
      name: "Bottle Opener",
      description: "Opens bottles.",
      price: 10.10,
      stock: 2,
      merchant: merchants(:brad),
      retired: false
    )
  }
  
  describe "instantiation" do
    it "can instantiate a valid product" do
      expect(new_product.save).must_equal true
    end
    
    it "will have the required fields" do
      new_product.save
      product = Product.last
      
      [:name, :description, :price, :stock, :merchant_id, :retired].each do |field|
        expect(product).must_respond_to field
      end
    end
  end
  
  describe "relationships" do
    describe "belongs to a merchant" do
      before do
        new_merchant = Merchant.create!(username: "Snoopy", email: "snoops@dog.com", uid: 876, provider: "Github")
        @new_merchant = Merchant.last
      end
      
      it "can set the merchant through merchant" do
        new_product.save!
        
        new_product.merchant = @new_merchant
        
        expect(new_product.merchant_id).must_equal @new_merchant.id
      end
      
      it "can set the merchant through merchant_id" do
        new_product.save!
        
        new_product.merchant_id = @new_merchant.id
        
        expect(new_product.merchant).must_equal @new_merchant
      end
    end
    
    it "can have many reviews" do
      review_1 = Review.new(rating: 1)
      review_2 = Review.new(rating: 2)
      review_3 = Review.new(rating: 3)
      
      new_product.save!
      new_product = Product.last
      
      new_product.reviews << review_1
      new_product.reviews << review_2
      new_product.reviews << review_3
      
      expect(new_product.reviews.count).must_be :>, 1
      
      new_product.reviews.each do |review|
        expect(review).must_be_instance_of Review
      end
    end
    
    it "can have many orderitems" do
      multi_order_prod = products(:heineken)
      
      expect(multi_order_prod.orderitems.count).must_be :>, 1
      
      multi_order_prod.orderitems.each do |orderitem|
        expect(orderitem).must_be_instance_of Orderitem
      end
    end
    
    it "can have many orders through orderitems" do
      multi_order_prod = products(:heineken)
      
      expect(multi_order_prod.orders.count).must_be :>, 1
      
      multi_order_prod.orders.each do |order|
        expect(order).must_be_instance_of Order
      end
    end
    
    it "has and belongs to types" do
      # WAIT FOR YAML FILES TO POPULATE
    end
  end
  
  describe "validations" do
    describe "name validation" do
      it "cannot create a Product with no name" do
        new_product.name = nil 
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :name
        expect(new_product.errors.messages[:name]).must_include "can't be blank"
      end
      
      it "cannot have a non-unique Product name" do
        new_product.name = "Sapporo" 
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :name
        expect(new_product.errors.messages[:name]).must_include "has already been taken"
      end
    end
    
    describe "price validation" do
      it "cannot create a Product with no price" do
        new_product.price = nil 
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :price
        expect(new_product.errors.messages[:price]).must_include "can't be blank"
      end
      
      it "cannot create a Product with a non-numerical price" do
        new_product.price = "abc"
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :price
        expect(new_product.errors.messages[:price]).must_include "is not a number"
      end
      
      it "cannot create a Product with a negative price" do
        new_product.price = -90
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :price
        expect(new_product.errors.messages[:price]).must_include "must be greater than 0"
      end
      
      it "cannot create a Product with price $0" do
        new_product.price = 0
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :price
        expect(new_product.errors.messages[:price]).must_include "must be greater than 0"
      end
      
      it "can create a Product with a price between 0-1 (float)" do
        new_product.price = 0.89
        
        expect(new_product.valid?).must_equal true
      end
    end
    
    describe "stock validation" do
      it "cannot create a Product with no stock" do
        new_product.stock = nil 
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :stock
        expect(new_product.errors.messages[:stock]).must_include "can't be blank"
      end
      
      it "cannot create a Product with a non-numerical stock" do
        new_product.stock = "abc"
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :stock
        expect(new_product.errors.messages[:stock]).must_include "is not a number"
      end
      
      it "cannot create a Product with a negative stock" do
        new_product.stock = -324
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :stock
        expect(new_product.errors.messages[:stock]).must_include "must be greater than or equal to 0"
      end
      
      it "can create a Product with 0 stock" do
        new_product.stock = 0
        
        expect(new_product.valid?).must_equal true
      end
      
      it "cannot create a Product with non-integer stock" do
        new_product.stock = 0.82
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :stock
        expect(new_product.errors.messages[:stock]).must_include "must be an integer"
      end
      
      it "cannot create a Product with a retired status nil" do
        new_product.retired = nil
        
        expect(new_product.valid?).must_equal false
        expect(new_product.errors.messages).must_include :retired
        expect(new_product.errors.messages[:retired]).must_include "retired status must be a boolean value: true or false"
      end
      
      it "will set the column value to true if non-valid entry is entered" do
        new_product.retired = 123
        
        expect(new_product.valid?).must_equal true
        
        new_product.save!
        updated_product = Product.find_by(id: new_product)
        
        expect(updated_product.retired).must_equal true
        expect(updated_product.retired).wont_equal 123
      end
    end
  end
  
end
