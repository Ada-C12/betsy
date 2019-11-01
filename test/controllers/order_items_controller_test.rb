require "test_helper"

describe OrderItemsController do
  describe "new" do
    it "can get the new order item path" do
      
      product = products(:product_1)
      
      get new_product_order_item_path(product.id)
      
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "creates an order item with valid data" do
      
      product = products(:product_1)
      
      order_item = {
        qty: 2,
        product_id: product.id
      }
      
      
      
      expect {
        post product_order_items_path(product.id), params: order_item
      }.must_change "OrderItem.count", 1
      oi = OrderItem.last
      
      must_respond_with :redirect
      must_redirect_to cart_path
    end
    
    it "does not create an order_item when bad data given" do
      product = products(:product_1)
      
      order_item = {
        qty: 0,
        product_id: product.id
      }
      
      
      
      expect {
        post product_order_items_path(product.id), params: order_item
      }.wont_change "OrderItem.count"
      
      
      must_respond_with :redirect
      
    end

    
  end
  
  describe "edit" do
    it "can get the edit order item path" do
      
      order_item = order_items(:oi1)
      
      get edit_order_order_item_path(order_item.order_id, order_item.id)
      
      must_respond_with :success
    end
    
  end
  
  describe "update" do
    
    it "updates an order item with valid data" do
      
      product = products(:product_1)
      order_item = order_items(:oi1)
      params = { 
        qty: 13 
      }
      
      
      
      expect {
        patch order_order_item_path(order_item.order_id, order_item.id), params: params
      }.wont_change "OrderItem.count"
      
      
      must_redirect_to cart_path
    end
    
    it "does not update an order_item when bad data given" do
      
      order_item = order_items(:oi1)
      
      params = { 
        qty: 0
      }
      
      
      
      expect {
        patch order_order_item_path(order_item.order_id, order_item.id), params: params
      }.wont_change "OrderItem.count"
      
      
      must_respond_with :redirect
      must_redirect_to cart_path
      
    end
  end
  
  describe "destroy" do
    it "can destroy an existing order item" do
      order_item = order_items(:oi1)
      
      expect {delete order_order_item_path(order_item.order_id, order_item.id)}.must_change "OrderItem.count", -1
    end
    
    it "will respond with a redirect when given a passenger that does not exist" do
      order_item = order_items(:oi1)
      delete order_order_item_path(order_item.order_id, -12)
      
      must_respond_with :redirect
      # expect(flash[:error]).must_equal "Could not find trip"
    end
  end
  
end