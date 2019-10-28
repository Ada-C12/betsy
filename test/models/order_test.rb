require "test_helper"

describe Order do
  let (:order1) {
    orders(:order1)
  }

  let (:pending_order) {
    orders(:pending_order)
  }
  
  it "can be instantiated" do
    expect(order1.valid?).must_equal true
  end
  
  it "will have the required fields" do
    expect(order1.email).wont_be_nil
    expect(order1.owling_address).wont_be_nil
    expect(order1.name_on_cc).wont_be_nil
    expect(order1.name).wont_be_nil
    expect(order1.cc_num).wont_be_nil
    expect(order1.cc_exp_mo).wont_be_nil
    expect(order1.cc_exp_yr).wont_be_nil
    expect(order1.cc_cvv).wont_be_nil
    expect(order1.zip_code).wont_be_nil
    expect(order1.status).wont_be_nil
    
    [:email, :owling_address, :name, :name_on_cc, :cc_num, :cc_exp_mo, :cc_exp_yr, :cc_cvv, :zip_code, :status].each do |attribute|
      expect(order1).must_respond_to attribute
    end
  end
  
  describe "relationships" do
    it "can have many order_items" do
      order_item = order_items(:order_items1)
      
      expect(order1.order_items.count).must_be :>=, 0
      order1.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end
  end
  
  describe "validations" do
    it "must have an order_item if not pending" do
      invalid_order = Order.create(email: 'bob@oz.com', owling_address: '123 Magical Lane', name: 'Bob Blah', cc_num: '1234567890123456', cc_exp_mo: 12, cc_exp_yr: 2020, cc_cvv: 123, zip_code: 12345, status: 'complete')
      
      expect(invalid_order.valid?).must_equal false
      expect(invalid_order.errors.messages).must_include :order_items
      expect(invalid_order.errors.messages[:order_items]).must_equal ["is too short (minimum is 1 character)"]
    end
    
    it "does not require an email if status is pending" do
      order1.email = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end

    it "must have an email" do
      order1.email = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :email
      expect(order1.errors.messages[:email]).must_include "can't be blank"
    end

    it "must have a valid email" do
      invalid_emails = ["peppermints.com", "muggle@domain", "applesauce"]
      invalid_emails.each do |invalid_email|
        order1.email = invalid_email
        expect(order1.valid?).must_equal false
        expect(order1.errors.messages).must_include :email
        expect(order1.errors.messages[:email]).must_include "is invalid"
      end
    end

    it "does not require an name if status is pending" do
      order1.name = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end
    
    it "must have a name" do
      order1.name = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :name
      expect(order1.errors.messages[:name]).must_equal ["can't be blank"]
    end
    
    it "does not require an owling_address if status is pending" do
      order1.owling_address = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end

    it "must have an owling_address" do
      order1.owling_address = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :owling_address
      expect(order1.errors.messages[:owling_address]).must_equal ["can't be blank"]
    end

    it "does not require a name_on_cc if status is pending" do
      order1.name_on_cc = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end

    it "must have an name_on_cc" do
      order1.name_on_cc = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :name_on_cc
      expect(order1.errors.messages[:name_on_cc]).must_equal ["can't be blank"]
    end

    it "does not require a cc_num if status is pending" do
      order1.cc_num = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end
    
    it "must have a cc_num" do
      order1.cc_num = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :cc_num
      expect(order1.errors.messages[:cc_num]).must_equal ["can't be blank"]
    end

    it "does not require a cc_exp_mo if status is pending" do
      order1.cc_exp_mo = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end
    
    it "must have a cc_exp_mo" do
      order1.cc_exp_mo = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :cc_exp_mo
      expect(order1.errors.messages[:cc_exp_mo]).must_equal ["can't be blank"]
    end

    it "must have a cc_exp_mo" do
      order1.cc_exp_mo = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :cc_exp_mo
      expect(order1.errors.messages[:cc_exp_mo]).must_equal ["can't be blank"]
    end

    it "does not require a cc_exp_yr if status is pending" do
      order1.cc_exp_yr = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end
    
    it "must have a cc_exp_yr" do
      order1.cc_exp_yr = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :cc_exp_yr
      expect(order1.errors.messages[:cc_exp_yr]).must_equal ["can't be blank"]
    end

    it "does not require a cc_cvv if status is pending" do
      order1.cc_cvv = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end
    
    it "must have a cc_cvv" do
      order1.cc_cvv = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :cc_cvv
      expect(order1.errors.messages[:cc_cvv]).must_equal ["is not a number", "can't be blank"]
    end

    it "cc_cvv must be number" do
      order1.cc_cvv = "not a number"
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :cc_cvv
      expect(order1.errors.messages[:cc_cvv]).must_equal ["is not a number"]
    end

    it "does not require a zip_code if status is pending" do
      order1.zip_code = nil
      order1.status = 'pending'
      
      expect(order1.valid?).must_equal true
      expect(order1.errors.messages).must_be_empty
    end
    
    it "must have a zip_code" do
      order1.zip_code = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :zip_code
      expect(order1.errors.messages[:zip_code]).must_equal ["is not a number", "is the wrong length (should be 5 characters)", "can't be blank"]
    end

    it "zip_code must be number" do
      order1.zip_code = "not a number"
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :zip_code
      expect(order1.errors.messages[:zip_code]).must_equal ["is not a number", "is the wrong length (should be 5 characters)"]
    end

    it "zip_code must be 5 length" do
      order1.zip_code = 1234
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :zip_code
      expect(order1.errors.messages[:zip_code]).must_equal ["is the wrong length (should be 5 characters)"]
    end

    it "must have a status" do
      order1.status = nil
      
      expect(order1.valid?).must_equal false
      expect(order1.errors.messages).must_include :status
      expect(order1.errors.messages[:status]).must_equal ["can't be blank"]
    end
  end

  describe "Custom methods" do
    describe "total" do
      it "accurately calculates the total" do
        expect(order1.order_items).wont_be_empty

        expect(order1.total).must_equal 3000
      end

      it "the total is 0 if there are no items" do
        OrderItem.delete_all
        expect(order1.order_items).must_be_empty

        expect(order1.total).must_equal 0
      end
    end

    describe "cancel_abandoned_orders" do
      it "can change an order to cancelled" do
        # expect(pending_order.status).must_equal 'pending'

        # pending_order.created_at = DateTime.now - 5
        # Order.cancel_abandoned_orders

        # expect(pending_order.status).must_equal 'cancelled'
      end

      it "only changes orders that are a day old" do

      end

      it "only changes pending orders" do

      end
    end
  end
end
