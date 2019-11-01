require "test_helper"

describe OrderItemsController do
  describe 'update' do
    it 'changes quantity on existing order_item in cart, and sets flash' do
      add_to_cart
      params = { order_item: { quantity: 2 } }
      expect{ patch update_cart_path(find_cart.order_items.first.id), params: params }.wont_change "OrderItem.count"
      expect(@cart.order_items.first.quantity).must_equal 2
      must_redirect_to cart_path
    end
    
    it 'sets flash and redirects for a non-existing order_item' do
      add_to_cart
      params = { order_item: { quantity: 2 } }
      expect{ patch update_cart_path(-1), params: params }.wont_change "OrderItem.count"
      assert flash[:messages]
      must_redirect_to cart_path
    end
    
    it 'redirects for an existing order_item not in cart' do
      add_to_cart
      params = { order_item: { quantity: 2 } }
      expect{ patch update_cart_path(order_items(:o_i_1).id), params: params }.wont_change "OrderItem.count"
      must_redirect_to cart_path
    end
    
  end
  
  describe 'destroy' do
    it 'removes existing order_item from the cart and db, then redirects' do
      add_to_cart
      expect(find_cart.order_items.count).must_equal 1
      order_item = @cart.order_items.first
      expect{ delete remove_from_cart_path(order_item) }.must_change "@cart.order_items.count", -1
    end
    
    it 'responds with bad request for non-existing order item' do
      add_to_cart
      expect{ delete remove_from_cart_path(order_items(:o_i_1)) }.wont_change "@cart.order_items.count"
      delete remove_from_cart_path(order_items(:o_i_1))
      must_respond_with :not_found
    end
    
    it 'responds with bad request for non-existing cart' do
      delete remove_from_cart_path(order_items(:o_i_1))
      must_respond_with :not_found
    end
  end
  
  describe "mark_shipped" do
    it "order item status changes" do
      #ATM checked using rails server
    end
    
    it "upon success, flash message appears and redirects to same page" do
      #ATM checked using rails server
    end
    
    it "if unsucessful, flash message appears and returns a 404, not found" do
      #ATM checked using rails server
    end
  end
end