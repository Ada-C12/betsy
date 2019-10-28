require "test_helper"

describe ReviewsController do
  it "must get new" do
    get reviews_new_url
    must_respond_with :success
  end

  it "must get create" do
    get reviews_create_url
    must_respond_with :success
  end

end
