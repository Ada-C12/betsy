require "test_helper"

describe OrderitemsController do
  let(:existing_orderitem) { orderitems(:heineken_oi) }
  
  let(:update_hash){
    {
      orderitem: {
        quantity: 1,
      },
    }
  }
  
  
  describe "create" do
    it "can create a new Orderitem with valid data" do
      expect {
        post product_orderitems_path(product_id: products(:stella).id), params: update_hash
      }.must_change "Orderitem.count", 1
      
      expect(session[:order_id]).wont_be_nil
      
      new_orderitem = Orderitem.last
      
      expect(new_orderitem.product.name).must_equal "Stella Artois"
      expect(new_orderitem.order.orderitems.count).must_equal 1
      must_respond_with :redirect
    end
    
    it "will instantiate a new order with ONLY orderitem and status" do
      expect {
        post product_orderitems_path(product_id: products(:stella).id), params: update_hash
      }.must_change "Order.count", 1
      
      new_order = Order.last
      
      expect(new_order).must_be_instance_of Order
      expect(new_order.orderitems.count).must_equal 1
      expect(new_order.status).must_equal "pending"
      expect(new_order.email).must_be_nil
      expect(new_order.address).must_be_nil
      expect(new_order.cc_name).must_be_nil
      expect(new_order.cc_num).must_be_nil
      expect(new_order.cvv).must_be_nil
      expect(new_order.cc_exp).must_be_nil
      expect(new_order.zip).must_be_nil
    end
    
    it "will add to existing Order while creating new Orderitems as separate orderitems" do
      expect {
        post product_orderitems_path(product_id: products(:stella).id), params: update_hash
      }.must_change "Orderitem.count", 1
      
      current_order = Order.find_by(id: session[:order_id])
      expect(current_order.orderitems.count).must_equal 1
      
      expect {
        post product_orderitems_path(product_id: products(:sapporo).id), params: update_hash
      }.wont_change "Order.count"
      
      expect(current_order.orderitems.count).must_equal 2
      must_respond_with :redirect
    end
    
    it "will add to the quantity of an existing Orderitem if adding the same product to the same order" do
      post product_orderitems_path(product_id: products(:sapporo).id), params: update_hash
      
      current_order = Order.find_by(id: session[:order_id])
      
      expect {
        post product_orderitems_path(product_id: products(:sapporo).id), params: update_hash
      }.wont_change "Orderitem.count"
      
      expect {
        post product_orderitems_path(product_id: products(:sapporo).id), params: update_hash
      }.wont_change "Order.count"
      
      orderitem = Orderitem.last 
      
      expect(current_order.orderitems.count).must_equal 1
      expect(orderitem.quantity).must_equal 3
      must_respond_with :redirect
    end
    
    it "will not create a new Orderitem if given an invalid product_id" do
      expect {
        post product_orderitems_path(product_id: -1), params: update_hash
      }.wont_change "Orderitem.count"
      
      must_respond_with :redirect
    end
    
    it "will not create a new Orderitem if given an invalid quantity" do
      invalid_hash = {
        orderitem: {
          quantity: nil,
        },
      }
      
      expect {
        post product_orderitems_path(product_id: products(:sapporo).id), params: invalid_hash
      }.wont_change "Orderitem.count"
      
      must_respond_with :redirect
    end
    
    it "will not create a new Orderitem if given an quantity greater than Product stock" do
      overstock_hash = {
        orderitem: {
          quantity: 20,
        },
      }
      
      expect {
        post product_orderitems_path(product_id: products(:sapporo).id), params: overstock_hash
      }.wont_change "Orderitem.count"
      
      must_respond_with :redirect
    end
  end
  
  describe "edit" do
    it "succeeds for a valid, existing orderitem ID" do
      existing_id = existing_orderitem.id
      get edit_orderitem_path(existing_id)
      
      must_respond_with :success
    end
    
    it "renders 404 not_found for an invalid orderitem ID" do
      get edit_orderitem_path(-1)
      
      must_respond_with :not_found
    end
  end
  
  describe "update" do
    it "succeeds for valid data and an existing orderitem ID, and redirects" do
      expect {
        patch orderitem_path(existing_orderitem.id), params: update_hash
      }.wont_change "Orderitem.count"
      
      updated_orderitem = Orderitem.find_by(id: existing_orderitem.id)
      
      expect(updated_orderitem.quantity).must_equal 1
      
      must_redirect_to order_path(updated_orderitem.order)
    end
    
    it "renders bad_request for invalid params data, and redirects" do
      invalid_hash = {
        orderitem: {
          quantity: nil,
        },
      }
      
      expect {
        patch orderitem_path(existing_orderitem.id), params: invalid_hash
      }.wont_change "Orderitem.count"
      
      updated_orderitem = Orderitem.find_by(id: existing_orderitem.id)
      expect(orderitems(:heineken_oi).quantity).must_equal 2
      
      must_respond_with :bad_request
    end
    
    it "renders 404 not_found for an invalid orderitem ID" do
      expect {
        patch orderitem_path(-1), params: update_hash
      }.wont_change "Orderitem.count"
      
      must_respond_with :not_found
    end
    
    it "redirects to root with no updates for orders with status other than pending" do
      existing_orderitem.order.status = "paid"
      existing_orderitem.order.save!
      
      updated_order = Order.find_by(id: existing_orderitem.order.id)
      
      expect(updated_order.status).must_equal "paid"
      
      expect {
        patch orderitem_path(existing_orderitem.id), params: update_hash
      }.wont_change "Orderitem.count"
      
      updated_orderitem = Orderitem.find_by(id: existing_orderitem.id)
      
      expect(updated_orderitem.quantity).must_equal 2
      
      must_redirect_to root_path
      
      expect(flash[:status]).must_equal :failure
    end
  end
  
  describe "destroy" do
    it "succeeds for a valid, existing orderitem ID, and redirects for a pending Order" do
      current_order = existing_orderitem.order
      
      expect {
        delete orderitem_path(existing_orderitem)
      }.must_change 'Orderitem.count', 1
      
      must_respond_with :redirect
      must_redirect_to order_path(current_order)
    end
    
    it "renders 404 not_found and does not update the DB for an invalid work ID" do
      expect {
        delete orderitem_path(id: -1)
      }.wont_change 'Orderitem.count'
      
      must_respond_with :not_found
    end
    
    it "cannot deleted an Orderitem in an Order that is not pending" do
      existing_orderitem.order.status = "paid"
      existing_orderitem.order.save!
      
      expect {
        delete orderitem_path(id: existing_orderitem.id)
      }.wont_change "Orderitem.count"
      
      must_redirect_to root_path
      
      expect(flash[:status]).must_equal :failure
    end
  end
  
  describe "mark_shipped" do
    it "will mark an orderitem as shipped if order status is paid and redirect" do
      expect(orderitems(:peach_op).shipped).must_equal false
      patch mark_shipped_path(id: orderitems(:peach_op).id)
      
      updated_peaches = Orderitem.find_by(id: orderitems(:peach_op).id)
      expect(updated_peaches.shipped).must_equal true
      
      expect(flash[:status]).must_equal :success
      must_respond_with :redirect
    end
    
    it "will change an order status to complete if it is marking the last not-shipped order item as shipped" do
      expect(orders(:fruit_order).status).must_equal "paid"
      
      patch mark_shipped_path(id: orderitems(:peach_op).id)
      
      updated_order = Order.find_by(id: orders(:fruit_order).id)
      expect(updated_order.status).must_equal "complete"
    end
    
    it "will respond with a failure flash message, redirect for an orderitem already marked as ship" do
      expect(orderitems(:banana_op).shipped).must_equal true
      patch mark_shipped_path(id: orderitems(:banana_op).id)
      
      updated_bananas = Orderitem.find_by(id: orderitems(:banana_op).id)
      expect(updated_bananas.shipped).must_equal true
      
      expect(flash[:status]).must_equal :failure
      must_respond_with :redirect
    end
    
    it "will respond with a failure flash message, redirect to root path for a non-paid order" do
      expect(orders(:cat_order).status).must_equal "pending"
      
      expect(orderitems(:cat_food_ok).shipped).must_equal false
      patch mark_shipped_path(id: orderitems(:cat_food_ok).id)
      
      updated_cat_food = Orderitem.find_by(id: orderitems(:cat_food_ok).id)
      expect(updated_cat_food.shipped).must_equal false
      
      expect(flash[:status]).must_equal :failure
      must_respond_with :redirect
    end
  end
end
