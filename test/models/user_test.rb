require "test_helper"

describe User do
  before do
    @user = User.create(username: 'john', email: 'john@example.com')#users(:valid)
    # @user.save!
  end
  
  describe 'relations' do
    it 'can have products' do
      expect(@user).must_respond_to :products
    end
    
    it 'can have no products' do
      assert_equal 0, @user.products.size
    end
    
    it 'can have one product' do
      @user.products << Product.new
      assert_equal 1, @user.products.size
    end
    it 'can have orders' do
      expect(@user).must_respond_to :orders
    end
    
    it 'can have one order' do
      @user.orders << Order.new
      assert_equal 1, @user.orders.size
    end
    
    it 'can have reviews' do
      expect(@user).must_respond_to :reviews
    end
  end
  
  
  # # still working on test.
  
  describe 'custom methods' do
    describe 'order_count' do
      it 'returns a hash of order count by status' do
        expect(users(:u_2).order_count).must_equal({ "paid" => 1, "complete" => 1 })
        expect(users(:u_1).order_count).must_equal({ "pending" => 2 })
      end
    end
    
    describe 'revenue' do
      # rewrite tests
      it 'accurately sums the merchants revenue from all orders' do
      end
      
      it 'returns 0 if the merchant has no orders' do
      end
    end
    
    describe 'revenues' do
      # rewrite tests
      it 'accurately returns revenues by status' do
      end
      
      it 'returns {} if the merchant has no orders' do
      end
      
    end
  end
  
  describe 'validation' do
    it 'invalid without username' do
      
      user = users(:invalid_without_username)
      user.valid?.must_equal false
      user.errors.messages.must_include :username
      # @user.username = nil
      # refute @user.valid?, 'saved user without a username'
      # assert_not_nil @user.errors[:username], 'no validation error for username present'
    end
    
    it 'invalid without email' do

      
      user = users(:invalid_without_email)
      user.valid?.must_equal false
      user.errors.messages.must_include :email
      # @user.email = nil
      # refute @user.valid?, 'saved user without an email'
      # assert_not_nil @user.errors[:email], 'no validation error for email present'
      
    end
    
    it "requires a unique username" do
      # skip
      
      username = "test username"
      email = 'test@email.com'
      user1 = User.new(username: username, email: email)
      
      # This must go through, so we use create!
      user1.save!
      
      user2 = User.new(username: username, email: email)
      result = user2.save
      expect(result).must_equal false
      expect(user2.errors.messages).must_include :username
    end 
    
    it 'requires an unique email' do
      # skip
      
      username1 = "testusername"
      email = 'test@email.com'
      user1 = User.new(username: username1, email: email)
      
      # This must go through, so we use create!
      user1.save!
      username2 = "test2username"
      user2 = User.new(username: username2, email: email)
      result = user2.save
      expect(result).must_equal false
      expect(user2.errors.messages).must_include :email
    end
  end
end
