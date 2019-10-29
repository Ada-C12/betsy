require "test_helper"

describe Order do
  describe "validations" do 
    let(:all_orders){Order.all}
    
    it "can be valid" do
      all_orders.each do |order|
        assert(order.valid?)
      end
    end
    
    it "will have the required fields" do
      all_orders.each do |order|
        [:status, :name, :email, :address, :cc_name, :cc_last4, :cc_exp, :cc_cvv, :billing_zip].each do |field|
          expect(order).must_respond_to field
        end
      end
    end
    
    it "requires a status to be present" do
      order = orders(:order_1)
      order.status = nil
      refute(order.valid?)
    end
    
    it "requires a name to be present if order status is paid" do
      order = orders(:order_1)
      order.name = nil
      refute(order.valid?)
    end
    
    it "requires an email to be present with @ symbol if order status is paid" do
      order = orders(:order_1)
      order.email = "aaa"
      refute(order.valid?)
    end
    
    it "requires a address to be present if order status is paid" do
      order = orders(:order_1)
      order.address = nil
      refute(order.valid?)
    end
    
    it "requires a cc_name to be present if order status is paid" do
      order = orders(:order_1)
      order.cc_name = nil
      refute(order.valid?)
    end
    
    it "requires a cc_last4 to be present if order status is paid" do
      order = orders(:order_1)
      order.cc_last4 = nil
      refute(order.valid?)
    end

    it "requires a cc_exp to be present if order status is paid" do
      order = orders(:order_1)
      order.cc_exp = nil
      refute(order.valid?)
    end

    it "requires a cc_cvv to be present if order status is paid" do
      order = orders(:order_1)
      order.cc_cvv = nil
      refute(order.valid?)
    end

    it "requires a billing zip to be present if order status is paid" do
      order = orders(:order_1)
      order.billing_zip = nil
      refute(order.valid?)
    end
  end
  
  describe "relationships" do
    it "can have many order items" do
      order = orders(:order_1)
      order_item1 = order_items(:order_item_1)
      order_item2 = order_items(:order_item_2)
      
      order.order_items << order_item1
      order.order_items << order_item2
      
      expect(order.order_items.count).must_be :>=, 0
      
      order.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end
  end

  describe "custom methods" do 

    describe "not pending" do 
      it "returns true for an order that is not pending" do
      
        order = orders(:order_1)
        assert(order.not_pending?) 

        order.status = "cancelled"
        assert(order.not_pending?)

        order.status = "completed"
        assert(order.not_pending?)
      end 

      it "returns false for an order that is pending" do 
        order = orders(:order_2)
        refute(order.not_pending?)
      end 
    end 

    describe "contain_orderitems?" do 
      it "returns true if the current user has a product in an order" do 
        order = orders(:order_1)
        user = users(:ada)
        
        assert(order.contain_orderitems?(user))
      end 

      it "returns false if the current user does not contain products in an order" do
        user = users(:gretchen)
        order = orders(:order_1) 
        refute(order.contain_orderitems?(user))
      end 
    end 

    describe "total" do 
      it "returns the total for all orderitems inside of a paid order" do
        order = orders(:order_1)
        
        expect(order.total).must_equal 305
      end 
      it "returns the total for all orderitems inside of a pending order" do 
        order = orders(:order_2)

        expect(order.total).must_equal 125
      end 
    end 
  end
end
