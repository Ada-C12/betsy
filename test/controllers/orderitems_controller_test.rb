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
  
  describe "create" do
    # TIFFANY FILL THIS IN AFTER YOU GET A ROUTE SET UP
  end
  
  describe "edit" do
    it "succeeds for a valid, existing orderitem ID" do
      existing_id = existing_orderitem.id
      get edit_orderitem_path(existing_id)
      
      must_respond_with :success
    end
    
    it "renders 404 not_found for an invalid orderitem ID" do
    end
  end
  
  describe "update" do
    it "succeeds for valid data and an existing orderitem ID, and redirects" do
    end
    
    it "renders bad_request for invalid data, and redirects" do
    end
    
    it "renders 404 not_found for an invalid orderitem ID" do
    end
  end
  
  describe "destroy" do
    it "succeeds for a valid, existing orderitem ID, and redirects" do
    end
    
    it "renders 404 not_found and does not update the DB for an invalid work ID" do
    end
  end
end
