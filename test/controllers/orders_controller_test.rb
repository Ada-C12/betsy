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
        updated_order = Order.find_by(id: orders(:fruit_order).id)
        
        expect(updated_order.status).must_equal "complete"
        
        get order_path(id: orders(:fruit_order))
        
        must_respond_with :success
      end
      
      it "responds with success for valid orders with cancelled status" do
        orders(:fruit_order).update!(status: "cancel")
        updated_order = Order.find_by(id: orders(:fruit_order).id)
        
        expect(updated_order.status).must_equal "cancel"
        
        get order_path(id: orders(:fruit_order))
        
        must_respond_with :success
      end
    end
    
    describe "cancel" do
      it "returns not found for the show action with an invalid ID" do
        patch cancel_order_path(id: -1)
        must_respond_with :not_found
      end
      
      it "redirects to root path with flash messages for orders with pending status" do
        patch cancel_order_path(id: orders(:order1))
        
        must_redirect_to root_path
        expect(flash[:status]).must_equal :failure
      end
      
      it "redirects to root path with flash messages for orders with complete status" do
        orders(:order1).update!(status: "complete")
        updated_order = Order.find_by(id: orders(:order1).id)
        
        expect(updated_order.status).must_equal "complete"
        
        patch cancel_order_path(id: orders(:order1))
        
        must_redirect_to root_path
        expect(flash[:status]).must_equal :failure
      end
      
      it "redirects to root path with flash messages for orders with cancel status" do
        orders(:order1).update!(status: "cancel")
        updated_order = Order.find_by(id: orders(:order1).id)
        
        expect(updated_order.status).must_equal "cancel"
        
        patch cancel_order_path(id: orders(:order1))
        
        must_redirect_to root_path
        expect(flash[:status]).must_equal :failure
      end
      
      it "changes status to cancel, returns product stock, and redirects to order path for valid orders with paid status" do
        expect(orders(:fruit_order).status).must_equal "paid"
        
        patch cancel_order_path(id: orders(:fruit_order))
        
        updated_order = Order.find_by(id: orders(:fruit_order).id)
        updated_carrot = Product.find_by(id: products(:carrot).id)
        updated_banana = Product.find_by(id: products(:banana).id)
        updated_peach = Product.find_by(id: products(:peach).id)
        
        expect(updated_order.status).must_equal "cancel"
        expect(updated_carrot.stock).must_equal 12
        expect(updated_banana.stock).must_equal 12
        expect(updated_peach.stock).must_equal 12
        
        must_redirect_to order_path(id: updated_order.id)
      end
    end
  end
  
  describe "initialized carts/orders" do
    before do
      post product_orderitems_path(product_id: products(:stella).id), params: { orderitem: { quantity: 1, }, }
    end
    
    describe "cart" do
      it "returns success for an existing session order id" do
        get cart_path
        must_respond_with :success
      end
    end
    
    describe "edit" do
      it "returns success for an existing session order id" do
        get edit_order_path(id: -1)
        must_respond_with :success
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

#   before do 
#     @order1 = Order.create email: "spinelli@recess.com", address: "1234 strawberrylane dr", cc_name: "ashley spinelli", cc_num: "23423434", cvv: "123", cc_exp: "12/20", zip: "98117", status: "pending"
#   end

#   describe "show" do
#     it "responds with success when a given id exist" do
#       valid_order = @order1

#       get order_path(valid_order.id)
#       must_respond_with :found      
#     end

#     it "will redirect w a flash error If the order id is not found" do
#       invalid_order = -1

#       get order_path(invalid_order)
#       must_redirect_to root_path

#       expect(flash[:failure]).must_equal "No items currently in cart."
#     end

#     it "redirect guest Users with empty carts" do
#       order = Order.create
#       get order_path(order.id)

#       must_redirect_to root_path
#     end
#   end #show/do


#   describe "edit" do
#     it "succeeds For an existing order ID" do
#       get edit_order_path(order.id)

#       must_respond_with :success
#     end
#   end #edit/do

#   describe "update" do
#     # i know update is all the way done, leaving it like this For now.
#     order = Order.create(status: "pending")
#     patch order_path(order), params: order_params
#     expect(flash[:message]).wont_be_nil
#     must_redirect_to order_path(order)
#     expect(session[:order_id]).must_be_nil #mustnotbenil?
#   end #update/do

#   describe "cancel" do
#     it "will update order status as cancelled" do

#     end
#   end #cancel/do

# end #end of orders controller desc
