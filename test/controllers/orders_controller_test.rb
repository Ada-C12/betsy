require "test_helper"

describe OrdersController do
  before do 
    
  end
  
  it "must get index" do
    get orders_index_url
    must_respond_with :success
  end
  
  it "must get new" do
    get orders_new_url
    must_respond_with :success
  end
  
  it "must get create" do
    get orders_create_url
    must_respond_with :success
  end
  
  it "must get update" do
    get orders_update_url
    must_respond_with :success
  end
  
  it "must get destroy" do
    get orders_destroy_url
    must_respond_with :success
  end
  
end
