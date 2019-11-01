require "test_helper"

describe OrdersController do
  describe "logged in user" do
    
    describe "cart" do
      it "can get the cart path" do
        perform_login
        
        get cart_path
        must_respond_with :success
      end
      
    end
    
    describe "show" do
      it "can get the show path for an order" do
        perform_login
        
        order = orders(:order1)
        
        get order_path(order.id)
        
        must_respond_with :success
        
      end
      
      it "will redirect when an order doesn't exist" do
        perform_login
        
        get order_path(-12)
        
        must_respond_with :redirect
        
      end
      
    end
    
    describe "edit" do
      
      it "can get the edit page for a valid order" do
        perform_login
        order = orders(:order1)
        
        get edit_order_path(order.id)
        
        must_respond_with :success
      end
      
      it "will redirect if given an invalid order" do
        perform_login
        
        
        get edit_order_path(-12)
        
        must_respond_with :redirect
        
      end
    end
    
    describe "checkout" do
      it "can get the checkout path" do
        perform_login
        
        get checkout_path
        must_respond_with :success
      end
      
    end
    
    describe "update" do
      it "can update an existin order with correct data" do
        perform_login
        order = orders(:order1)
        
        updates = {
          order: {
            status: "paid"
          }
        }
        
        expect{ patch order_path(order.id), params: updates }.wont_change "Order.count"
      end

      it "won't update an existing order with bad data" do
        perform_login
        order = orders(:order1)
        
        updates = {
          order: {
            status: "paid",
            name: ""
          }
        }
        
        expect{ patch order_path(order.id), params: updates }.wont_change "Order.count"
      end
      
    end

    describe "confirmation" do
      it "can get the confirmation path" do
        perform_login
        
        get confirmation_path
        
        must_respond_with :success
      end
    end
  end
  
  describe "guest user" do
    describe "cart" do
      it "can get the cart path" do
        
        get cart_path
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "can't get the show path for an order" do
        
        
        order = orders(:order1)
        
        get order_path(order.id)
        
        must_respond_with :redirect 
        must_redirect_to root_path
        
      end
      
    end
    
    describe "edit" do
      
      it "can't get the edit page for a valid order" do
        
        order = orders(:order1)
        
        get order_path(order.id)
        
        must_respond_with :redirect
        
        
      end
    end
    
    describe "checkout" do
      it "can get the checkout path" do
        perform_login
        
        get checkout_path
        must_respond_with :success
      end
      
    end
    
    describe "update" do
      it "can update an existing order with correct data" do
        perform_login
        
        order = orders(:order1)
        
        updates = {
          order: {
            status: "paid",
            email: "kristy@ada.com",
            ccnum: 1234345656678788
          }
        }
        
        expect{ patch order_path(order.id), params: updates }.wont_change "Order.count"
        
        
        updated_order = Order.find_by(id: order.id)
        
        expect(order.id).must_equal updated_order.id
        expect(order.ccnum).wont_equal updated_order.ccnum
        
      end

  
    end

    describe "confirmation" do
      it "can get the confirmation path" do
        
        @order = orders(:order2)
        
        get confirmation_path
        
        must_respond_with :success
      end
    end 
  end
end