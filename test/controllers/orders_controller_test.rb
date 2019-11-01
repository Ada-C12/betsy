require "test_helper"
require 'pry'

describe OrdersController do
# no index view page so deleting tests for index
  describe 'show' do
    it 'responds with success when showing a valid order (cart)' do
      valid_order = Order.first
      get order_path(valid_order.id)
      must_respond_with :success
    end
    it 'responds with failure when asked to show an invalid order (cart)' do
      get order_path(-42)
      must_redirect_to products_path
    end
  end

  describe 'new/create action' do
    it 'can create a new order' do
      get new_order_path
      must_respond_with :success
    end
    it 'creates a new order when a guest adds a product to the cart' do
      product_id = products(:clown).id
      expect { post product_orderproducts_path(product_id) }.must_differ 'Order.count', 1
    end
  end

  describe 'update action' do
    it 'enables buyer to check out' do
      product_id = products(:clown).id
      post product_orderproducts_path(product_id)
      order = Order.last
      checkout_hash = {
      order: {
      name: "Tummy",
      email: "tummy@petsy.com",
      mailing_address: "123 Pine St.",
      zip: 12345,
      name_on_cc: "Tummy B. Button",
      cc_number: 2520240451111111,
      cc_exp: "11/9/19",
      cc_cvc: 345,
      status: "paid"}}
      expect{ patch order_path(order.id), params: checkout_hash }.wont_change Order.count
      must_redirect_to confirmation_path
    end
    it 'responds appropriately if order placement unsuccessful' do
      product_id = products(:clown).id
      post product_orderproducts_path(product_id)
      order = Order.last
      checkout_hash = {
        order: {
        email: "tummy@petsy.com",
        mailing_address: "123 Pine St.",
        zip: 12345,
        name_on_cc: "Tummy B. Button",
        cc_exp: "11/9/19",
        cc_cvc: 345,
        status: "paid"}}
      patch order_path(order.id), params: checkout_hash
      expect(flash[:danger]).must_include "Order failed"
    end

    it 'decreases quantity purchased from product stock' do
      valid_product = products(:clown)
      cur_id = valid_product.id
      post product_orderproducts_path(cur_id)
      order = Order.last
      checkout_hash = {
      order: {
      name: "Tummy",
      email: "tummy@petsy.com",
      mailing_address: "123 Pine St.",
      zip: 12345,
      name_on_cc: "Tummy B. Button",
      cc_number: 2520240451111111,
      cc_exp: "11/19",
      cc_cvc: 345,
      status: "paid"}}
      expect{ patch order_path(order.id), params: checkout_hash }.wont_change Order.count
      updated_order = Order.find_by(id: order.id)
      updated_product = updated_order.products.first
      expect(updated_order.name).must_equal checkout_hash[:order][:name]
      expect(updated_order.status).must_equal "paid"
      expect(updated_product.stock).must_equal 19
    end
  end
end
