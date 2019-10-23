require "test_helper"

describe MerchantsController do
  
  let(:merchant) { merchants(:brad) }

  describe "index" do
    it "responds with success when there are many drivers" do
      get merchants_path
      must_respond_with :success
    end
  end
  
end
