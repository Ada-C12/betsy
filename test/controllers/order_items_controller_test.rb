require "test_helper"

describe OrderItemsController do
  describe "create" do
    before do
      @product = Product.first
    end

    it "successfully creates a new order item, if given valid params, and responds with a redirect" do
      order_items_hash = {
        order_item: {
          quantity: 1
        }
      }

      expect {
        post product_order_items_path(@product.id), params: order_items_hash
      }.must_differ 'OrderItem.count', 1
      
      must_respond_with :redirect
      assert_equal "#{@product.name} successfully added to your basket! (quantity: #{order_items_hash[:order_item][:quantity]})", flash[:success]
    end

    it "does not create a new oder item if given invalid params and responds with a redirect" do
      order_items_hash = {
        order_item: {
          quantity: 0
        }
      }

      expect {
        post product_order_items_path(@product.id), params: order_items_hash
      }.wont_differ 'OrderItem.count'

      must_respond_with :redirect
      assert_equal "#{@product.name} was not added to your basket.", flash[:error]
    end

    it "does not create a new order item if the product does not exit and responds with a 404" do
      product_id = -1
      order_items_hash = {
        order_item: {
          quantity: 0
        }
      }

      expect {
        post product_order_items_path(product_id), params: order_items_hash
      }.wont_differ 'OrderItem.count'

      must_respond_with :not_found
      assert_equal "Product no longer exists.", flash[:error]
    end

    it "does not create a new order item if the quantity entered is greater than the product stock" do
      product = products(:strawberry_shoes)
      expect(product.stock).must_equal 2

      order_item_hash = {
        order_item: {
          quantity: 7
        }
      }

      expect {
        post product_order_items_path(product.id), params: order_item_hash
      }.wont_differ 'OrderItem.count'

      must_respond_with :redirect
      assert_equal "Quantity entered (#{order_item_hash[:order_item][:quantity]}) is greater than available stock for #{product.name}.", flash[:error]
    end

    it "does not create a new order item if the current order already contains an order item with the same product" do
      OrderItem.destroy_all
      product = products(:lemon_shirt)
      product_id = product.id
      order_item_hash = {
        order_item: {
          quantity: 1
        }
      }
      post product_order_items_path(product_id), params: order_item_hash
      order = Order.last
      

      order_item_hash_2 = {
        order_item: {
          quantity: 2
        }
      }

      expect {
        post product_order_items_path(product_id), params: order_item_hash_2
      }.wont_differ 'OrderItem.count'

      order_item = OrderItem.last
      expect(order.order_items.length).must_equal 1
      expect(order_item.quantity).must_equal 3
      expect(order_item.product.name).must_equal product.name
    end
  end

  describe "update" do
    before do
      @order_item = OrderItem.first
    end

    it "can update an existing order item accurately and redirects to the cart path" do
      id = @order_item.id
      
      updated_order_item_hash = {
        order_item: {
          quantity: 7
        }
      }
      expect(@order_item.quantity).wont_equal updated_order_item_hash[:order_item][:quantity]

      expect {
        patch order_item_path(id), params: updated_order_item_hash
      }.wont_differ "OrderItem.count"

      expect(OrderItem.find_by(id: id).quantity).must_equal updated_order_item_hash[:order_item][:quantity]
      must_redirect_to cart_path
      assert_equal "#{@order_item.product.name} successfully updated!", flash[:success]
    end

    it "does not update the order item if given invalid params and redirects to the cart path" do
      id = @order_item.id
      
      invalid_order_item_hash = {
        order_item: {
          quantity: "a lot"
        }
      }

      expect {
        patch order_item_path(id), params: invalid_order_item_hash
      }.wont_differ "OrderItem.count"

      must_redirect_to cart_path
      assert_equal "Could not update quantity for #{@order_item.product.name}.", flash[:error]
    end

    it "does not update the order item if the quantity entered is greater than the product stock" do
      product = products(:strawberry_shoes)
      expect(product.stock).must_equal 2

      order_item = order_items(:order_item_2)
      id = order_item.id

      order_item_hash = {
        order_item: {
          quantity: 7
        }
      }

      expect {
        patch order_item_path(id), params: order_item_hash
      }.wont_differ "OrderItem.count"

      must_redirect_to cart_path
      assert_equal "Quantity entered (#{order_item_hash[:order_item][:quantity]}) is greater than available stock for #{product.name}.", flash[:error]
    end
  end

  describe "destroy" do
    before do
      @order_item = OrderItem.last
    end

    it "successfully deletes an existing order item and redirects to the cart path" do
      order_item = @order_item
      id = order_item.id

      expect{
        delete order_item_path(id)
      }.must_differ "OrderItem.count", -1
      
      assert_nil(OrderItem.find_by(id: id))
      must_redirect_to cart_path
      assert_equal "#{order_item.product.name} successfully removed from your basket!", flash[:success]
    end

    it "redirects to the cart path and deletes no order items if the order item does not exist" do
      invalid_id = -1

      expect{
        delete order_item_path(invalid_id) 
      }.wont_differ "OrderItem.count"

      must_redirect_to cart_path
    end

    it "redirects to the cart path and deletes no order items if the order item has already been deleted" do
      id = @order_item.id

      OrderItem.destroy(id)

      expect{
        delete order_item_path(id) 
      }.wont_differ "OrderItem.count"

      must_redirect_to cart_path
    end
  end
end
