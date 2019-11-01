require "test_helper"

describe HomepagesController do
  describe "index" do
    it "gives back a successful response" do
      get root_path
      must_respond_with :success
    end
  end
end
