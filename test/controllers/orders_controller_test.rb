require "test_helper"

describe OrdersController do
  before do 
    @order1 = Order.create email: "spinelli@recess.com", address: "1234 strawberrylane dr", cc_name: "ashley spinelli", cc_num: "23423434", cvv: "123", cc_exp: "12/20", zip: "98117", status: "pending"
  end
  
  describe "show" do
    it "responds with success when a given id exist" do
      valid_order = @order1
      
      get order_path(valid_order.id)
      must_respond_with :found      
    end
    
    it "will redirect w a flash error If the order id is not found" do
      invalid_order = -1
      
      get order_path(invalid_order)
      must_redirect_to root_path
      
      expect(flash[:failure]).must_equal "No items currently in cart."
    end
    
    it "redirect guest Users with empty carts" do
      order = Order.create
      get order_path(order.id)
      
      must_redirect_to root_path
    end
  end #show/do
  
  
  describe "edit" do
    it "succeeds For an existing order ID" do
      get edit_order_path(order.id)
      
      must_respond_with :success
    end
  end #edit/do
  
  describe "update" do
    # i know update is all the way done, leaving it like this For now.
    order = Order.create(status: "pending")
    patch order_path(order), params: order_params
    expect(flash[:message]).wont_be_nil
    must_redirect_to order_path(order)
    expect(session[:order_id]).must_be_nil #mustnotbenil?
  end #update/do
  
  describe "cancel" do
    it "will update order status as cancelled" do
      
    end
  end #cancel/do
  
end #end of orders controller desc