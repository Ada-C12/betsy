require "test_helper"

describe OrderItem do
  describe "validations" do
    it "can be valid" do
      order_items = OrderItem.all

      order_items.each do |item|
        assert(item.valid?)
      end
    end

  end

  describe "relationships" do
    #belongs to product
    #test OrderItem.product

    #belongs to order
    #test OrderItem.order
    

  end
end
