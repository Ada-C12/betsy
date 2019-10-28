require "test_helper"

describe TypesController do
  let (:existing_type) {types (:lager)}
end
describe "show" do 
  it "will responds with success when the given type_id exist"
  
  valid_type = Type.create(:lager)
  
  get types_path(valid_type.id)
  must_respond_with :success
end




end#end of types controller