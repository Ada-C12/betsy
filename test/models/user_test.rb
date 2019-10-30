require "test_helper"

describe User do
  describe "validations" do 
    before do
      @users = User.all
    end
    
    it "can be valid" do
      @users.each do |user|
        assert(user.valid?)
      end
    end
    
    it "will have the required fields" do
      @users.each do |user|
        [:uid, :merchant_name, :email, :provider, :username].each do |field|
          expect(user).must_respond_to field
        end
      end
    end
    
    it "requires a unique uid" do
      user = users(:ada)
      taken_uid = users(:betsy).uid
      user.uid = taken_uid
      
      refute(user.valid?)
    end
    
    it "requires a unique username" do
      user = users(:ada)
      taken_username = users(:betsy).username
      user.username = taken_username
      
      refute(user.valid?)
    end
    
    it "requires a unique email address" do
      user = users(:ada)
      taken_email = users(:betsy).email
      user.email = taken_email
      
      refute(user.valid?)
    end
    
    it "must have a unique merchant name, if present" do
      user = users(:ada)
      taken_merchant_name = users(:betsy).merchant_name
      user.merchant_name = taken_merchant_name
      
      refute(user.valid?)
    end
    
    it "requires merchant_name to be less than 50 characters" do
      user = users(:gretchen)
      user.merchant_name = (0...51).map { ('a'..'z').to_a[rand(26)] }.join
      
      refute(user.valid?)
    end
    
    it "requires an at symbol (@) to be present in the email address" do
      user = users(:betsy)
      user.email = "bfruitstand.com"
      
      refute(user.valid?)
    end
  end
  
  describe "relationships" do
    it "can have many products" do
      user = users(:ada)
      product_1 = Product.first
      product_2 = Product.last
      
      user.products << product_1
      user.products << product_2
      
      expect(user.products.count).must_be :>=, 0
      
      user.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
    
    it 'can have many reviews' do
      review1 = reviews(:good_review) 
      review2 = reviews(:okay_review) 
      user = users(:ada)
      
      expect(user.reviews.count).must_equal 2
      user.reviews.each do |review|
        expect(review).must_be_instance_of Review
      end
    end
  end 
  
  describe "custom methods" do 
    
    describe "total earned" do 
      it "returns the total revenue a user has earned on orders that are completed and/or paid" do
        user = users(:ada)
        expect(user.total_earned).must_be_instance_of Float
        expect(user.total_earned).must_equal 330
      end 
      
      it "returns 0 if the user has not sold any products" do 
        user = User.create(username: "aaaawooo", email: "werewolf@mail.com", uid: 23542)
        expect(user.total_earned).must_equal 0 
      end 

      it "will not display total earned for orders that are cancelled " do 
        user = users(:betsy)
        expect(user.total_earned).must_equal 0
      end 
    end 
    
    describe "find order items" do
      it "returns an array of all order items belonging to a user" do
        user = users(:ada)
        expect(user.find_order_items).must_be_instance_of Array
        expect(user.find_order_items.first).must_be_kind_of OrderItem
      end 
      
      it "contains accurate orderitems for a user" do 
        user = users(:ada)
        order_item = order_items(:order_item_1)
        expect(user.find_order_items.first).must_equal order_item
        expect(user.find_order_items.first.product.name).must_equal "Lemon Shirt"
      end 
    end 
    
    describe "find products" do 
      it "finds all products belonging to a user" do 
        user = users(:ada)
        expect(user.find_products.first).must_be_kind_of Product
      end 
      
      it "won't return any products if a user has none" do 
        user = users(:gretchen)
        expect(user.find_products.first).must_equal nil 
      end 
    end 
    
    describe "filter order items" do
      it "returns an array of all order items with a specific order status belonging to an user" do
        user = users(:ada)
        ["paid", "cancelled", "completed"].each do |status|
          expect(user.filter_order_items(status)).must_be_instance_of Array 
        end
      end 
      
      it "contains accurate orderitems for a user" do 
        user = users(:ada)
        order_item = order_items(:order_item_1)
        order_items = user.filter_order_items('paid')
        expect(order_items.first).must_equal order_item
        expect(order_items.first.product.name).must_equal order_item.product.name
      end 
    end
  end
end
