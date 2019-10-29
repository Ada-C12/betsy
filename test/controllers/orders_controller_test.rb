require "test_helper"

describe OrdersController do
  let(:order_items1) { order_items(:order_items1) }
  let(:product1) { products(:product1) }
  let(:order1) { orders(:order1) }
  let(:pending_order) { orders(:pending_order)}
  
  describe "cart" do
    it "finds the order in session and responds with success" do
      new_item = { 
        order_item: { 
          quantity: 1, 
          product: product1,
          order: order1,
          shipped: false
        }
      }
      post product_order_items_path(product1.id), params: new_item
      
      order = Order.last
      
      expect(session[:order_id]).must_equal order.id
      
      get cart_path
      must_respond_with :success
    end
    
    it "finds responds with success when no order is in session" do
      get cart_path
      must_respond_with :success
    end
  end
  
  describe "checkout" do
    it "responds with a success for valid id" do
      new_item = { 
        order_item: { 
          quantity: 1, 
          product: product1,
          order: order1,
          shipped: false
        }
      }
      post product_order_items_path(product1.id), params: new_item
      order = Order.last
      
      get checkout_path(order.id)
      
      must_respond_with :success
    end
    
    it "redirects with invalid id" do
      get checkout_path(-20)
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
  
  describe "update" do
    before do
      @updates = { 
        order: { 
          email: 'bob@oz.com',
          owling_address: '123 Magical Lane',
          name: 'Bob Blah',
          name_on_cc: 'Bob Blah',
          cc_num: '1234567890123456',
          cc_exp_mo: '12',
          cc_exp_yr: '2020',
          cc_cvv: 123,
          zip_code: 12345,
        } 
      }
    end
    it "succeeds for valid data and valid ID" do
      new_item = { 
        order_item: { 
          quantity: 1, 
          product: product1,
          order: order1,
          shipped: false
        }
      }
      
      post product_order_items_path(product1.id), params: new_item
      pending_order = Order.last
      
      expect {
        put order_path(pending_order.id), params: @updates
      }.wont_change "Order.count"
      
      updated_order = Order.find_by(id: pending_order.id)
      
      updated_order.email.must_equal 'bob@oz.com'
      updated_order.owling_address.must_equal '123 Magical Lane'
      updated_order.name.must_equal 'Bob Blah'
      updated_order.name_on_cc.must_equal 'Bob Blah'
      updated_order.cc_num.must_equal '1234567890123456'
      updated_order.cc_exp_mo.must_equal '12'
      updated_order.cc_exp_yr.must_equal '2020'
      updated_order.cc_cvv.must_equal 123
      updated_order.zip_code.must_equal 12345
      updated_order.status.must_equal 'paid'
      
      must_respond_with :redirect
      must_redirect_to confirmation_path
    end
    
    it "updates product stock when order successfully updates" do
      new_item = { 
        order_item: { 
          quantity: 2, 
          product: product1,
          order: order1,
          shipped: false
        }
      }
      
      post product_order_items_path(product1.id), params: new_item
      pending_order = Order.last
      
      expect(product1.stock).must_equal 10
      
      put order_path(pending_order.id), params: @updates
      
      product1.reload
      
      expect(product1.stock).must_equal 8
    end
    
    it "status stays pending for bad data" do
      @updates[:order][:email] = nil
      
      expect {
        put order_path(pending_order), params: @updates
      }.wont_change "Order.count"
      
      order = Order.find_by(id: pending_order.id)
      
      must_respond_with :not_found
    end
    
    it "renders 404 not_found for a invalid ID" do
      put order_path(-20), params: @updates
      
      must_respond_with :not_found
    end
  end
  
  def confirmation
    
  end
end
