require "test_helper"

describe OrderitemsController do
  let(:new_orderitem) {
    Orderitem.new(
      quantity: 1,
      product: products(:stella),
      order: orders(:order_1)
    )
  }
  
  let(:existing_orderitem) { orderitems(:heineken_oi) }
  
  let(:update_hash){
    {
      orderitem: {
        quantity: 1,
      },
    }
  }
  
  
  describe "create" do
    it "can create an orderitem with valid data" do
      # TIFFANY I THINK YOU NEED TO SOMEHOW SIMULATE SETTING AN ORDER_ID IN SESSION
      
      # session_hash = { order_id: Orderitem.last.id }
      
      # expect {
      #   post product_orderitems_path(product_id: Product.first.id), params: update_hash
      # }.must_change "Orderitem.count", 1
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
      
      # TIFFANY YOU NEED TO FILL THIS IN ONCE YOU FIX REDIRECT
      # must_redirect_to
    end
    
    it "renders bad_request for invalid data, and redirects" do
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
  end
  
  describe "destroy" do
    it "succeeds for a valid, existing orderitem ID, and redirects" do
      
      # TIFFANY YOU NEED TO FILL THIS IN ONCE YOU FIX REDIRECT
      
      expect {
        delete orderitem_path(existing_orderitem)
      }.must_change 'Orderitem.count', 1
      
      must_respond_with :redirect
      # must_redirect_to
    end
    
    it "renders 404 not_found and does not update the DB for an invalid work ID" do
      # TIFFANY YOU NEED TO FILL THIS IN ONCE YOU FIX REDIRECT
      
      expect {
        delete orderitem_path(id: -1)
      }.wont_change 'Orderitem.count'
      
      must_respond_with :not_found
    end
  end
end
