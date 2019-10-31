require "test_helper"

describe OrderItemsController do
  let(:order_items1) { order_items(:order_items1) }
  let(:product1) { products(:product1) }
  let(:order1) { orders(:order1) }
  let(:pending_order_items) { order_items(:pending_order_items) }
  let(:order_items2) { order_items(:order_items2) }
  
  describe "create" do
    it "creates an order_item with an order for a real product" do
      new_item = { 
        order_item: { 
          quantity: 1, 
          product: product1,
          order: order1,
          shipped: false
        }
      }
      
      expect {
        post product_order_items_path(product1.id), params: new_item
      }.must_change "OrderItem.count", 1
      
      new_item_id = OrderItem.find_by(order: order1).id
      
      must_respond_with :redirect
      must_redirect_to product_path(product1.id)
    end
    
    it "creates an order if the first item" do
      new_item = { 
        order_item: { 
          quantity: 1, 
          product: product1,
          order: order1,
          shipped: false
        }
      }
      
      expect {
        post product_order_items_path(product1.id), params: new_item
      }.must_change "Order.count", 1
    end
    
    it "doesn't create an order if not the first item" do
      order_items1
      item2 = { 
        order_item: { 
          quantity: 1, 
          product: product1,
          order: order1,
          shipped: false
        }
      }
      
      expect {
        post product_order_items_path(product1.id), params: item2
      }.must_change "Order.count", 0
    end
    
    it "responds with redirect if order_item cannot be created" do
      invalid_item = { 
        order_item: { 
          quantity: 1, 
          product: nil,
          order: nil,
          shipped: false
        }
      }
      
      post product_order_items_path(product1.id), params: invalid_item
      
      must_respond_with :redirect
      must_redirect_to product_path(product1.id)
    end
  end
  
  describe "update" do
    it "succeeds for valid data" do
      order_items1
      
      update_item = { 
        order_item: { 
          quantity: 5
        } 
      }
      
      expect {
        put order_item_path(order_items1), params: update_item
      }.wont_change "OrderItem.count"
      
      updated_item = OrderItem.find_by(id: order_items1.id)
      
      updated_item.quantity.must_equal 5
      must_respond_with :redirect
      must_redirect_to cart_path
    end
    
    it "redirects if quantity is less than 0" do
      order_items1
      
      update_item = { 
        order_item: { 
          quantity: 0
        } 
      }
      
      expect {
        put order_item_path(order_items1), params: update_item
      }.wont_change "OrderItem.count"
      
      updated_item = OrderItem.find_by(id: order_items1.id)
      
      updated_item.quantity.must_equal 2
      must_respond_with :redirect
      must_redirect_to cart_path
    end
    
    it "redirects if quantity is not integer" do
      order_items1
      
      update_item = { 
        order_item: { 
          quantity: "nope"
        } 
      }
      
      expect {
        put order_item_path(order_items1), params: update_item
      }.wont_change "OrderItem.count"
      
      updated_item = OrderItem.find_by(id: order_items1.id)
      
      updated_item.quantity.must_equal 2
      must_respond_with :redirect
      must_redirect_to cart_path
    end
    
    it "renders 404 not_found for invalid ID" do
      invalid_id = -20
      
      update_item = { 
        order_item: { 
          quantity: 5
        } 
      }
      
      put order_item_path(invalid_id), params: update_item
      
      must_respond_with :not_found
    end
  end
  
  describe "destroy" do
    it "succeeds for a valid ID" do
      order_items1
      expect {
        delete order_item_path(order_items1.id)
      }.must_change "OrderItem.count", -1
      
      must_respond_with :redirect
      must_redirect_to cart_path
    end
    
    it "renders 404 not_found and does not update the DB for an invalid work ID" do
      invalid_id = -20
      
      expect {
        delete order_item_path(invalid_id = -20)
      }.wont_change "OrderItem.count"
      
      must_respond_with :not_found
    end
  end
  
  describe "shipped" do
    it "updates order_item shipped status to true" do
      patch shipped_path(order_items2.id)
      
      must_respond_with :redirect
      
      order_items2.reload
      expect(order_items2.shipped).must_equal true
    end
    
    it "responds with not_found for invalid ID" do
      patch shipped_path(-20)
      
      must_respond_with :not_found
    end
    
    it "does not update shipped to true and redirects if order is not paid" do
      patch shipped_path(pending_order_items.id)
      
      must_respond_with :redirect
      
      pending_order_items.reload
      expect(pending_order_items.shipped).must_equal false
    end
  end
end
