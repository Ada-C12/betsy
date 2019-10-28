require "test_helper"

describe Order do
  let (:order1) {
    Order.create email: spinelli@recess.com, address: 1234 strawberrylane dr., cc_name: ashley spinelli, cc_num: 23423434, ccv: 123, cc_exp: 12/20, zip: 98117, status: pending
  }
end
describe "show" do
  it "will create an order"
  order = orders(:order1)
  
  get order_path(order)
  
  must_respond_with :success
end



end
