require "test_helper"

describe Category do
  describe "initialize" do
    before do
      @new_category = Category.new(name: "The Best Category")
    end

    it "can be instantiated" do
      expect(@new_category.valid?).must_equal true
    end

    it "will have the required fields" do
      expect(@new_category).must_respond_to :name
      
    end
  end

  describe "relationships" do

    let(:bubbly) { categories(:bubbly) }
    let(:goat) { categories(:goat)}
    describe "products" do

      it "should have a list of products" do
        expect(bubbly.products.count).must_equal categories(:bubbly).products.count

        expect(goat.products.count).must_equal 0
      end

      it "can set a product through category" do
        bubbly.products.push(products(:onion))

        expect(bubbly.products).must_include products(:onion)
        expect(bubbly.products).must_include products(:potter)
      end
    end
    
    

    it "should remove category relation when a product is deleted" do
      before_count = categories(:bubbly).products.count
      potter = products(:potter)
      potter.destroy
      expect(bubbly.products.count).must_equal (before_count - 1) 
    end
  end

  describe "validations" do
  let(:bubbly) { categories(:bubbly) }
    it "should have a name that is a string" do
      expect(bubbly.name).must_be_instance_of String
      expect(bubbly.name).must_equal categories(:bubbly).name
    end

    it "should validate the presence of name" do
      # I need a teammate to confirm that this model test is comprehensive
      bubbly.name = ""
      expect(bubbly.name).must_equal ""
      expect(bubbly.errors).wont_be_nil
    end
  end
end
