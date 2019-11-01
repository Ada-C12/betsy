require "test_helper"

describe Orderproduct do
  describe 'validations' do
    before do
      @orderproduct = orderproducts(:op1)
    end
    it 'is valid when quantity is present and a positive integer' do
      expect(@orderproduct.valid?).must_equal true
    end
    it 'is invalid when quantity is not present' do
      @orderproduct.quantity = nil
      expect(@orderproduct.valid?).must_equal false
      expect(@orderproduct.errors.messages).must_include :quantity
    end
    it 'is invalid when quantity is not positive' do
      @orderproduct.quantity = 0
      expect(@orderproduct.valid?).must_equal false
      expect(@orderproduct.errors.messages).must_include :quantity
    end
  end

  describe 'relations' do
    it 'orderproduct has a product' do
      orderproduct = orderproducts(:op3)
      orderproduct.product.must_equal products(:magician)
    end
    it 'orderproduct has an order' do
      orderproduct = orderproducts(:op2)
      orderproduct.order.must_equal orders(:d)
    end
     it 'can set the product' do
      op = Orderproduct.new
      op.product = products(:taco)
      op.product_id = products(:taco).id
     end

     it 'can set the order' do
      op = Orderproduct.new
      op.order = orders(:c)
      op.order_id = orders(:c).id
     end
  end
end
