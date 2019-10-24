require "test_helper"

describe UsersController do
  describe "current" do
    it "responds with success when a user has logged in" do
      perform_login

      get current_user_path

      must_respond_with :success
    end

    it "responds with not_found when a user hasn't logged in" do
      get current_user_path

      must_respond_with :not_found
    end
  end 

  describe "create" do
  end

  describe "edit" do

  end

  describe "update" do
  end

  describe "destroy" do
  end
end
