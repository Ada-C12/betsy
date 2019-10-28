require "test_helper"

describe OrdersController do
  let(:valid_params){
    {
      order: {
        email: "anything@gmail.com",
        address: "123 abcstreet",
        cc_name: "Mochi Cat",
        cc_num: 12345,
        cvv: 123,
        cc_exp: 12/2019,
        zip: 11111,
      },
    }
  }
  
  describe "empty/uninitialized carts/orders" do
    it "returns redirect to root path with a flash message for the cart action" do
      get cart_path
      
      must_respond_with :redirect
      must_redirect_to root_path
      
      expect(flash[:status]).must_equal :failure
    end
    
    it "returns not found for the edit action" do
      get edit_order_path(id: Order.first.id)
      must_respond_with :not_found
    end
    
    it "returns not found for the update action" do
      expect { patch order_path(id: Order.first.id), params: valid_params }.wont_change "Order.count"
      must_respond_with :not_found
    end
    
    describe "show" do
      it "returns not found for the show action with an invalid ID" do
        get order_path(id: -1)
        must_respond_with :not_found
      end
      
      it "redirects to root path with flash messages for orders with valid IDs but pending status" do
        get order_path(id: orders(:order1))
        
        must_redirect_to root_path
        expect(flash[:status]).must_equal :failure
      end
      
      it "responds with success for valid orders with paid status" do
        get order_path(id: orders(:fruit_order))
        
        must_respond_with :success
      end
      
      it "responds with success for valid orders with completed status" do
        orders(:fruit_order).update!(status: "complete")
        
        get order_path(id: orders(:fruit_order))
        
        must_respond_with :success
      end
      
      it "responds with success for valid orders with cancelled status" do
        orders(:fruit_order).update!(status: "cancel")
        
        get order_path(id: orders(:fruit_order))
        
        must_respond_with :success
      end
    end
    
    describe "cancel" do
    end
    
    
    it "returns not found the cancel action (invalid id)" do
      # expect { patch cancel_order_path(id: orders(:order1)) }.wont_change "Order.count"
      # must_respond_with :not_found
    end
  end
  
  describe "initialized carts/orders" do
    
    before do
      post product_orderitems_path(product_id: products(:stella).id), params: { orderitem: { quantity: 1, }, }
    end
    
    describe "cart" do
      it "returns success for an existing order id" do
        get cart_path
        must_respond_with :success
      end
      
      it "" do
      end
      
      it "" do
      end
      
      it "" do
      end
    end
    
    describe "edit" do
      it "returns success for an existing order id" do
      end
      
      it "" do
      end
    end
    
    describe "update" do
      it "returns success for an existing order id" do
      end
      
      it "" do
      end
      
      it "" do
      end
      
      it "" do
      end
      
      it "" do
      end
      
      it "" do
      end
    end
    
  end
end
