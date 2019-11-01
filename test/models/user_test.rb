require "test_helper"

describe User do
  describe "validations" do
    it "can be valid" do
      is_valid = users(:valid_user).valid?
      
      assert( is_valid )
    end
    
    it "is invalid if there is no name" do
      invalid_user = users(:valid_user)
      invalid_user.name = ""
      
      is_valid = invalid_user.valid?
      
      refute( is_valid )
    end
    
    it "gives an error message if the name given is not unique" do
      invalid_user = users(:valid_user2)
      invalid_user.name = "ValidName"
      
      is_valid = invalid_user.valid?
      
      refute( is_valid )
    end
    
    it "is invalid if there is no email" do
      invalid_user = users(:valid_user)
      invalid_user.email = ""
      
      is_valid = invalid_user.valid?
      
      refute( is_valid )
    end
    
    it "gives an error message if the email given is not unique" do
      invalid_user = users(:valid_user2)
      invalid_user.email = "valid@user.org"
      
      is_valid = invalid_user.valid?
      
      refute( is_valid )
    end
  end
  
  describe "relationships" do
    it "has products" do
      user = User.first
      
      product = Product.create(name: "product", price: 599.99, qty: 5, user_id: user.id)
      
      expect(user).must_respond_to :products
      user.products.each do |product|
        expect(product).must_be_kind_of Product
      end 
    end
  end
  
  describe "custom methods" do
    it "calculates total revenue correctly" do
      user = users(:valid_user)
      
      expect(user.total_revenue).must_equal "1899.93"
    end
    
    it "calculates total revenue correctly for a status" do
      user = users(:valid_user)
      
      expect(user.total_revenue("complete")).must_equal "1699.95"
    end
    
    it "calculates the total number of orders correctly" do
      user = users(:valid_user)
      
      expect(user.order_list.count).must_equal 3
    end
    
    it "calculates the total number of orders correctly for a status" do
      user = users(:valid_user)
      
      expect(user.order_list("paid").count).must_equal 1
    end
  end
end
