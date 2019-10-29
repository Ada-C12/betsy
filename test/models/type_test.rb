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
  
  describe "relationships" do
    
    it "[type] can have many products" do
      types(:light).products << products(:stella)
      types(:light).products << products(:corona)
      
      updated_light = Type.find_by(id: types(:light).id)
      
      expect(updated_light.products.find_by(id: products(:stella).id)).wont_be_nil
      expect(updated_light.products.find_by(id: products(:corona).id)).wont_be_nil
      expect(updated_light.products.count).must_equal 2
    end
    
    it "[type] can belong to many products" do
      #want to create products (2), and give them the same type, assertion is:
      
      products(:sapporo).types << types(:light)
      products(:corona).types << types(:light)
      # types(:light).products << products(:corona)
      
      updated_product = Product.find_by(id: products(:sapporo).id)
      # updated_product = Product.new
      
      expect(updated_product.types.find_by(id: products(:stella).id)).must_equal nil
      expect(updated_product.types.find_by(id: products(:corona).id)).must_equal nil
      expect(updated_product.types.count).must_equal 1
    end
    
  end
  
  
end#end of relationship/Do

