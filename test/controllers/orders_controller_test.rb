require "test_helper"

describe OrdersController do
  let(:order_items1) { order_items(:order_items1) }
  let(:product1) { products(:product1) }
  let(:order1) { orders(:order1) }

  describe "cart" do
    it "finds the order in session" do
      new_item = { 
        order_item: { 
          quantity: 1, 
          product: product1,
          order: order1,
          shipped: false
        }
      }
      post product_order_items_path(product1.id), params: new_item

      order = Order.last

      expect(session[:order_id]).must_equal order.id

      get cart_path
      must_respond_with :success
    end
  end
end
