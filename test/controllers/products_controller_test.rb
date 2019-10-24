require "test_helper"

describe ProductsController do
  describe "index action" do

    it "gives back a successful response" do
      # Arrange
      # ... Nothing right now!

      # Act
      # Send a specific request... a GET request to the path "/books"
      get products_path

      # Assert
      # The response was OK!
      must_respond_with :success
    end

  end
end
