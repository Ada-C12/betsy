require "test_helper"

describe Category do
  before do
    @category = categories(:strawberry)
  end

    it "can be instantiated" do
      assert(@category.valid?)
    end

  it "will have the required fields" do
    [:name, :category_type ].each do |field|
      expect(@category).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many products" do   
      
    end
  end

  describe "validations" do
    describe 'name' do 
      it "must have a name" do
        @category.name = nil
        
        refute(@category.valid?)
        expect(@category.errors.messages).must_include :name
        expect(@category.errors.messages[:name]).must_include "can't be blank"
      end
    end
  end

  describe 'custom methods' do
    describe 'products_by_category' do
      it 'returns products for a give cateogry given the string name' do
        category = Category.create(name: "lemon", category_type: "fruit")
        
        Product.create(name:"Lemon Thing", price: 25, quantity: 5, img_url:"https://img.com", user: users(:ada), description: "description", category_ids: [category.id])
        lemon_products = Category.products_by_category("lemon")
        expect(lemon_products.count).must_equal 1

        Product.create(name:"Lemon Thing2", price: 25, quantity: 5, img_url:"https://img.com", user: users(:ada), description: "description", category_ids: [category.id])
        lemon_products = Category.products_by_category("lemon")
        expect(lemon_products.count).must_equal 2
      end
      
      it 'returns nil if unknown category given' do
        category = Category.create(name: "lemon", category_type: "fruit")
        Product.create(name:"Lemon Thing", price: 25, quantity: 5, img_url:"https://img.com", user: users(:ada), description: "description", category_ids: [category.id])
        lemon_products = Category.products_by_category("invalid")
        assert_nil(lemon_products)
      end

      it 'returns [] if none in given category' do
        category = Category.create(name: "lemon", category_type: "fruit")
        lemon_products = Category.products_by_category("lemon")
        expect(lemon_products).must_equal []
      end
    end
  end
end

