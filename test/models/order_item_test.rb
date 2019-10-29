require "test_helper"

describe OrderItem do
  before do
    @order_items = OrderItem.all
  end

  describe "validations" do
    it "can be valid" do
      @order_items.each do |item|
        assert(item.valid?)
      end
    end

    it "will have the required fields" do
      @order_items.each do |item|
        [:product_id, :order_id, :quantity ].each do |field|
          expect(item).must_respond_to field
        end
      end
    end

    it "requires a quantity greater than 0" do
      order_item = OrderItem.first
      order_item.quantity = 0

      refute(order_item.valid?)
    end

    it "must have a quantity that is an integer" do
      order_item = OrderItem.new(product: Product.first, order: Order.first, quantity: "a lot")

      refute(order_item.valid?)
    end

    it "must have a valid product" do
      invalid_order_item = OrderItem.new(quantity: 4, product_id: -1, order: Order.first)

      refute(invalid_order_item.valid?)
    end

    it "must have a valid order" do
      invalid_order_item = OrderItem.new(quantity: 4, product: Product.first, order_id: -1)

      refute(invalid_order_item.valid?)
    end

    #the quantity must not exceed the quantity of the product.stocko
  end

  describe "relationships" do
    before do
      @product = Product.first
      @order = Order.last
    end

    it "can set the product through 'product'" do
      order_item = OrderItem.new(quantity: 2, order: @order) 

      order_item.product = @product

      expect(order_item.product_id).must_equal @product.id
    end

    it "can set the product through 'product_id'" do
      order_item = OrderItem.new(quantity: 2, order: @order) 

      order_item.product_id = @product.id

      expect(order_item.product).must_equal @product
    end

    it "can set the order through 'order'" do
      order_item = OrderItem.new(quantity: 2, product: @product) 

      order_item.order = @order

      expect(order_item.order_id).must_equal @order.id
    end

    it "can set the order through 'order_id'" do 
      order_item = OrderItem.new(quantity: 2, product: @product) 

      order_item.order_id = @order.id

      expect(order_item.order).must_equal @order
    end
  end

  describe "increase_quantity" do
    it "accurately increases the quantity of an existing order item" do
      order_item = OrderItem.first
      expect(order_item.quantity).must_be :<, 5
      new_quantity = 5

      order_item.increase_quantity(new_quantity)

      expect(order_item.quantity).must_be :>, 5
    end

    #edge case?


  end
end
