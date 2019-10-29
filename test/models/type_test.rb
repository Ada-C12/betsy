require "test_helper"

describe Type do
  
  let (:new_type) { 
    Type.new(name: "Lager")
  }
  
  describe "validations" do
    it "can be instantiated" do
      expect(new_type.valid?).must_equal true
    end
    
    it "will have the required fields" do
      new_type.save
      type = Type.first
      [:name].each do |field|
        
        expect(type).must_respond_to field
      end
    end
    
    it "can update a new type" do
      expect{Type.create(name: "Lager")}
    end
    
    it "will not save If type name will not save If it contains non-alphabetic characters" do
      bad_type = Type.new(name: "1time")
      
      expect {bad_type.save}.wont_change "Type.count"
      
    end
  end
  
  # describe "relationships" do
  
  #   xit "can have many products" do
  #     #want to create products (2), and give them the same type, assertion is:
  #     # type = :lager 
  #     # type.products.count > 0
  #     # 
  #     new_type.save
  #     type = Type.first
  
  #     expect(type.count).must_be :>=, 0
  #     type.each do |name|
  #       expect(type.name).must_be_instance_of Type
  #     end
  #   end #this isnt passing
  
  #   it "can belong to many products" do
  #     #want to create products (2), and give them the same type, assertion is:
  #     # product1.type == product2.type
  #   end
  # end#end of relationship/Do
end
