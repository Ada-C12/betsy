require "test_helper"

describe Product do
  it "can be instantiated" do
    product = products(:lemon_shirt)
    assert(product.valid?)
  end

  it "will have the required fields" do
    product = products(:lemon_shirt)
    [:name, :price, :quantity, :img_url, :user_id, :categories, :description ].each do |field|
      expect(product).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many order items" do
      product = products(:lemon_shirt)      
      order_item1 = OrderItem.create(quantity: 1, product_id: product.id)
      order_item2 = OrderItem.create(quantity: 1, product_id: product.id)
      
      expect(product.order_items.count).must_equal 2
    end
    
    it "can have many categories" do
      product = products(:lemon_shirt)
      expect(product.categories.count).must_equal 1
      expect(product.categories.first).must_equal categories(:lemon)
      
      product.categories << categories(:strawberry)
      expect(product.categories.count).must_equal 2
      expect(product.categories.last).must_equal categories(:lemon)
      expect(product.categories.first).must_equal categories(:strawberry)
    end

    it "can have one user" do
      product = products(:lemon_shirt)
      expect(product.user).must_equal users(:ada)
    end
  end

  describe "validations" do
    it "must have a category" do
    end

  end

end
