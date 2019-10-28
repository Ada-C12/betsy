require "test_helper"

describe OrdersController do
  describe "complete_purchase" do
    before do
      @order = orders(:o_1)
      @user = User.find_by(id: @order.user_id)
    end
    
    it "completing a purchase changes an order's status" do
      expected_order_status = "paid"
      @order.status = "pending"
      complete_purchase_path(@order.id)
      expect(@order.status).must_equal expected_order_status
      
    end
    
    it "completing a purchase adjusts the stock amount for related products" do
      #finds products associated with order
      # @order = 
      @products = Product.where(id: OrderItem.find_by(order_id: @order.id).product_id)
      
      @products.first.stock = 100
      
      post complete_purchase_path(@order.id)
      
      expect(Product.find_by(id: OrderItem.find_by(order_id: @order.id).product_id)).stock must_equal 4
      
    end
    
    
    it "completing a purchase is not allowed if user's information is missing" do
    end
    
    
  end
  
  
  
end
