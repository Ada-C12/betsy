require "test_helper"

describe OrderItem do
  describe 'relations' do
    it 'has a product' do
      expect(OrderItem.new).must_respond_to :product
    end
    
    it 'has an order' do
      expect(OrderItem.new).must_respond_to :order
    end
  end
  
  describe 'custom methods' do
    describe 'total' do
      it 'returns an integer total price in cents' do
        expect(order_items(:o_i_1).total).must_equal 1200000
      end
    end
  end
  
  describe 'validations' do
    describe 'in_stock' do
      it 'wont create an order_item with a quantity larger than the products stock' do
        skip
        product = products(:p_1)
        order_item = OrderItem.new(product: product, quantity: product.stock.succ)
        refute order_item.valid?
      end
      
      it 'will create an order_item with a quantity less than or equal to the products stock' do
        order = orders(:o_1)
        product = products(:p_1)
        assert product.stock > 0
        
        order_item = OrderItem.new(order: order, product: product, quantity: product.stock)
        assert order_item.valid?
        
        order_item = OrderItem.new(order: order, product: product, quantity: 1)
        assert order_item.valid?
      end
    end
  end
end
