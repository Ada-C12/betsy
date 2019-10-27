require "test_helper"

describe Orderitem do
  let(:new_orderitem) {
    Orderitem.new(
      quantity: 1,
      product: products(:stella),
      order: orders(:order1),
      shipped: false
    )
  }
  
  describe "validation" do
    it "can instantiate a valid orderitem" do
      expect(new_orderitem.save).must_equal true
    end
    
    it "has all required fields" do
      new_orderitem.save
      orderitem = Orderitem.last
      
      [:quantity, :product_id, :order_id].each do |field|
        expect(orderitem).must_respond_to field
      end
    end
    
    it "cannot create an orderitem with no quantity" do
      new_orderitem.quantity = nil
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :quantity
      expect(new_orderitem.errors.messages[:quantity]).must_include "can't be blank"
    end
    
    it "cannot create an orderitem with negative quantity" do
      new_orderitem.quantity = -9
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :quantity
      expect(new_orderitem.errors.messages[:quantity]).must_include "must be greater than 0"
    end
    
    it "cannot create an orderitem with quantity = 0" do
      new_orderitem.quantity = 0
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :quantity
      expect(new_orderitem.errors.messages[:quantity]).must_include "must be greater than 0"
    end
    
    it "cannot create an orderitem with a non-numeric quantity" do
      new_orderitem.quantity = "nine"
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :quantity
      expect(new_orderitem.errors.messages[:quantity]).must_include "is not a number"
    end
    
    it "cannot create an orderitem with a non-integer quantity" do
      new_orderitem.quantity = 0.999999
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :quantity
      expect(new_orderitem.errors.messages[:quantity]).must_include "must be an integer"
    end
    
    it "cannot create an orderitem with an invalid product" do
      new_orderitem.product_id = -1
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :product
      expect(new_orderitem.errors.messages[:product]).must_include "must exist"
    end
    
    it "cannot create an orderitem with an invalid order" do
      new_orderitem.order_id = -1
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :order
      expect(new_orderitem.errors.messages[:order]).must_include "must exist"
    end
    
    it "cannot create an orderitem with quantity greater than stock available" do
      new_orderitem.quantity = 10
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :quantity
      expect(new_orderitem.errors.messages[:quantity]).must_include "order exceeds inventory in stock"
    end
    
    it "cannot create an orderitem from a retired product" do
      products(:stella).update(retired: true)
      expect(products(:stella).retired).must_equal true
      
      expect(new_orderitem.valid?).must_equal false
      expect(new_orderitem.errors.messages).must_include :product_id
      expect(new_orderitem.errors.messages[:product_id]).must_include "Stella Artois is no longer available"
    end
  end
  
  describe "relationships" do
    it "belongs to a product" do
      new_orderitem.save!
      
      expect(new_orderitem.product_id).must_equal products(:stella).id
      expect(new_orderitem.product).must_equal products(:stella)
    end
    
    it "belongs to an order" do
      new_orderitem.save!
      
      expect(new_orderitem.order_id).must_equal orders(:order1).id
      expect(new_orderitem.order).must_equal orders(:order1)
    end
  end
  
  describe "custom methods" do
    describe "subtotal" do
      it "can calculate the correct subtotal" do
        expect(orderitems(:heineken_oi).subtotal).must_be_close_to 22.22
      end
    end
  end
end
