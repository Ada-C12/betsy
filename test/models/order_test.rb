require "test_helper"

describe Order do
  
  describe 'relations' do
    it 'has_many order_items' do
      expect(Order.new).must_respond_to :order_items
    end
    
    it 'has a user' do
      expect(Order.new).must_respond_to :user
    end
  end
  
  describe 'custom methods' do
    describe 'revenue' do
      it 'returns an accurate total cost of all order items' do
        expect(orders(:o_1).revenue).must_equal 9600
        # 100 * 90 + 100 * 6
      end
    end
  end
  
  describe "validations upon creation" do
    it "requires a user" do
      order = Order.new
      order.user_id = nil
      order.status = "pending"
      refute(order.valid?)      
    end
    
    it "requires initial has status at creation" do 
      order = Order.new
      order.user_id = 111
      refute(order.valid?)  
    end 
    
    it "status can only be pending, paid, complete or cancelled" do 
      order = Order.first
      order.status = "working on it"
      refute(order.valid?)
    end
    
    it "valid status are only pending, paid, complete or cancelled" do
      order = Order.first
      assert(order.valid?)
    end
  end
  
  describe "validations when paying" do
    before do
      @order = Order.last
      @user = User.find_by(id: @order.user_id)
    end
    it "when paying, meething the minimum of 1 order is necessary" do
      assert(@order.valid?)
    end
    it "when not paying, the minimum order items is ignored" do
      OrderItem.destroy_all
      @order.status = "pending"
      assert(@order.valid?)
    end
    it "when not paying, the minimum order items is enforced" do
      OrderItem.destroy_all
      @order.status = "paid"
      refute(@order.valid?)
    end
  end
  
  describe "destruction test" do
    it "checks if destruction stuck" do
      expect(OrderItem.count).must_equal 20
    end
  end
  
  describe "order_inspection" do
    it "with order inspection, if the related order_items have status of shipped the order status is changed to complete" do
    end
    
    it "with order inspection, if the related order_items have mixed strata, the order status is unchanged" do
    end
    
  end
end