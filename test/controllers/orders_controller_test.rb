require "test_helper"

describe OrdersController do
  describe "show action" do
    it "responds with a success when an order id given exists and the logged in user has products in this order" do
      order = orders(:order_1)
      user = users(:ada)
      perform_login(user)
      
      get order_path(order.id)
      must_respond_with :success
    end
    
    it "responds with a redirect when an order id given exists and the logged in user didn't sell products in this order" do
      order = orders(:order_1)
      user = users(:betsy)
      perform_login(user)
      
      get order_path(order.id)
      must_redirect_to root_path
    end
    
    it "responds with a not_found when id given does not exist" do
      user = users(:betsy)
      perform_login(user)
      order_id = -10000
      
      get order_path(order_id)
      must_respond_with :not_found
    end
  end
  
  describe "cart action" do
    it "gives back a successful response" do
      product = products(:lemon_shirt)
      product_id = product.id
      order_item_hash = {
        order_item: {
          quantity: 1
        }
      }
      post product_order_items_path(product_id), params: order_item_hash

      get cart_path
      must_respond_with :success
    end
  end
  
  describe "checkout action" do
    before do 
      product = products(:lemon_shirt)
      @product_id = product.id
      @order_item_hash = {
        order_item: {
          quantity: 1
        }
      }
    end

    it "gives back a successful response if there are some items in the cart" do
      post product_order_items_path(@product_id), params: @order_item_hash

      get checkout_path
      
      must_respond_with :success
    end
    
    it "responses with redirect if no item is in the cart" do
      post product_order_items_path(@product_id), params: @order_item_hash

      OrderItem.destroy_all

      get checkout_path
      
      must_redirect_to root_path
      assert_equal "No item in the cart! Please add some items then checkout!", flash[:error]
    end
    
    it "responses with redirect if order doesn't exist" do
      post product_order_items_path(@product_id), params: @order_item_hash

      OrderItem.destroy_all
      Order.destroy_all

      get checkout_path
      
      must_redirect_to root_path
      assert_equal "Order doesn't exist!", flash[:error]
    end
  end
  
  describe "update_paid action" do
    let(:order){
      Order.create(status: "pending")
    }
    
    let(:payment_params){
      {
        order: {
          name: "Gretchen Wieners",
          email: "so_fetch@aol.com",
          address: "124 Main Street",
          cc_name: "Dave Wieners",
          cc_last4: 6666,
          cc_exp: "12/23",
          cc_cvv: 365,
          billing_zip: '98122'
        }
      }
    }

    let(:empty_payment_params){
      {
        order: {
          name: nil,
          email: nil,
          address: nil,
          cc_name: nil,
          cc_last4: nil,
          cc_exp: nil,
          cc_cvv: nil,
          billing_zip: nil
        }
      }
    }
    
    it "updates the order information and changes the order status to paid, then redirects to confirmation page" do 
      order.save
      
      expect{
        patch order_path(order.id), params: payment_params
      }.must_differ "Order.count", 0
      
      find_order = Order.find_by(id: order.id)
      
      payment_params[:order].each do |k, v|
        expect(find_order[k]).must_equal v
      end
      
      expect(find_order.status).must_equal "paid"
      
      must_redirect_to confirmation_path
      
      assert_equal "Order #{find_order.id} has been purchased successfully!", flash[:success]
    end
    
    it "redirects to the cart path if the params is invalid and doesn't change the order status" do 
      order.save
      
      expect{
        patch order_path(order.id), params: empty_payment_params
      }.must_differ "Order.count", 0
      
      find_order = Order.find_by(id: order.id)
      
      expect(find_order.status).must_equal "pending"
      
      must_redirect_to cart_path
      
      assert_equal "Something went wrong! Order was not paid.#{find_order.errors.messages}", flash[:error]
    end
  end
  
  describe "confirmation action" do
    before do 
      product = products(:lemon_shirt)
      @product_id = product.id
      @order_item_hash = {
        order_item: {
          quantity: 1
        }
      }
    end

    it "gives back a successful response if the order is paid" do
      post product_order_items_path(@product_id), params: @order_item_hash
      
      get confirmation_path
      must_respond_with :success
    end
    
    it "responses with redirect if current order does not exist" do
      post product_order_items_path(@product_id), params: @order_item_hash
      OrderItem.destroy_all
      Order.destroy_all

      get confirmation_path

      must_redirect_to root_path
      assert_equal "Order doesn't exist!", flash[:error]
    end
  end

  describe "cancel_order action" do
    before do 
      @order = orders(:order_1)
      @user = users(:ada)
    end

    it "changes the order status to cancelled and gives back a redirect response by logged in merchant who sells products in this order" do
      perform_login(@user)
      patch cancel_order_path(@order.id)

      find_order = Order.find(@order.id)
      expect(find_order.status).must_equal 'cancelled'

      must_redirect_to current_user_path

      assert_equal "Order #{@order.id} has been cancelled successfully!", flash[:success]
    end
    
    it "doesn't change the order status and gives back a redirect response by logged in merchant who doesn't sell products in this order" do
      user = users(:gretchen)
      perform_login(user)
      patch cancel_order_path(@order.id)

      find_order = Order.find(@order.id)
      expect(find_order.status).must_equal 'paid'
      
      must_redirect_to current_user_path
      assert_equal "You're not allowed to cancel this order!", flash[:error]
    end

    it "gives back a redirect response if order id is not found" do
      perform_login(@user)
      patch cancel_order_path(-1)

      must_redirect_to current_user_path
      assert_equal "Something went wrong, cannot cancel order!", flash[:error]
    end
  end


end
