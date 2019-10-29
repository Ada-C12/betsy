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
    
  end
end
