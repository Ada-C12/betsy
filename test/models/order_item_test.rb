require "test_helper"

describe OrderItem do
  describe "relationships" do
    it "belongs to a product" do
      oi = order_items(:oi1)
      expect(oi.product).must_be_kind_of Product
    end

    it "belongs to an order" do
      oi = order_items(:oi1)
      expect(oi.order).must_be_kind_of Order
    end
  end

  describe "increase_qty" do
    it "will increase the qty of an order item by the number passed in" do
      oi = order_items(:oi1)
      oi.increase_qty(5)
      expect(oi.qty).must_equal 8
    end
  end
end
