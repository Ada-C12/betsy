require "test_helper"

describe OrderproductsController do
  # had written index and show tests, but Rails objected bc there aren't views for those
  
  describe 'create' do
    it 'can create a new orderproduct with valid information' do
      product_id = products(:clown).id
      expect { post product_orderproducts_path(product_id) }.must_differ 'Orderproduct.count', 1
    end
    
    it 'does not create an orderproduct if the product is out of stock' do
      product = products(:wizard)
      post product_orderproducts_path(product.id) # this takes the only one in stock
      expect { post product_orderproducts_path(product.id) }.wont_change 'Orderproduct.count'
      expect(flash[:danger]).must_include "Sorry"
      must_redirect_to products_path
    end
    
    it 'uses the session order id for the orderproduct order id if the is in an existing order / can add a product to an order that does not yet contain it, and creates a new orderproduct in the process' do
      product_id = products(:clown).id
      post product_orderproducts_path(product_id)
      num_orders = Order.count
      order = Order.last
      num_ops = order.orderproducts.count
      second_product = products(:taco)
      post product_orderproducts_path(second_product.id)
      # a new Order isn't created
      expect(Order.count).must_equal num_orders
      # there is another orderproduct within the order
      expect(order.orderproducts.count).must_equal num_ops + 1
    end
    
    it 'does not let buyer add product to the cart if cart contains full stock of a product' do
      product = products(:magician)
      product.stock = 1
      post product_orderproducts_path(product.id)
      post product_orderproducts_path(product.id)
      must_respond_with 302
      must_redirect_to products_path
    end
    
    it 'can add product to cart that already contains that item if not yet maxed out, and increases quantity by one' do
      product_id = products(:batman).id
      post product_orderproducts_path(product_id)
      order = Order.last
      second_product = products(:batman)
      post product_orderproducts_path(second_product.id)
      op = order.orderproducts.last
      expect(op.quantity).must_equal 2
    end
  end
  
  describe 'update orderproduct quantity' do
    it 'can change the quantity of an orderproduct in an order and save it' do
      product = products(:clown)
      post product_orderproducts_path(product.id)
      order = Order.last
      op = order.orderproducts.last
      id = op.id
      orderproduct_hash = {
      orderproduct: {
      quantity: 5
      }}
      expect{ patch orderproduct_path(op.id), params: orderproduct_hash }.wont_change Orderproduct.count
      must_respond_with :redirect
      updated_op = Orderproduct.find_by(id: id)
      expect(updated_op.quantity).must_equal 5
    end
  end
  
  describe 'destroy' do
    it 'can delete an item from the cart' do
      product = products(:clown)
      post product_orderproducts_path(product.id)
      second_product = products(:batman)
      post product_orderproducts_path(second_product.id)
      order = Order.last
      op = Orderproduct.last
      expect{delete orderproduct_path(op.id)}.wont_change Order.count
      expect(order.orderproducts.count).must_equal 1
      expect(Orderproduct.last.product_id).must_equal product.id
    end
  end
end
