require "test_helper"

describe Review do
  before do
    @review = reviews(:good_review)
  end

  it "can be instantiated" do
    assert(@review.valid?)
  end

  it "will have the required fields" do
    [:rating, :description, :user_id, :product_id].each do |field|
      expect(@review).must_respond_to field
    end
  end

  describe "relationships" do
    # it "can have many order items" do   
    #   product = Product.create(
    #     name: "Orange Soap Dispenser",
    #     price: 20.00,
    #     quantity: 15,
    #     img_url: "http:\\fakeurl.com",
    #     user: users(:betsy),
    #     description: "A soap dispenser shaped like an orange."
    #   )

    #   product.order_items << OrderItem.create(quantity: 2, product: product, order: Order.first)
    #   product.order_items << OrderItem.create(quantity: 3, product: product, order: Order.last)

    #   expect(product.order_items.count).must_equal 2
    # end
end
end
