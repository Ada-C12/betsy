require "test_helper"
describe ProductsController do
  describe "index" do 
    before do 
      # Arrange
      hot_dog = Product.create(name: "Hot Dog", price: 25.00, stock: 12, description: "Fido will look good enough to eat in this weiner suit!", photo: nil, retire: false, merchant_id: 1)
      unicorn_horn = Product.create(name: "Unicorn Horn", price: 14.00, stock: 78, description: "Your cat or dog will look majestic in this delightful unicorn horn. (No unicorns were harmed to make this product.)", photo: nil, retire: false, merchant_id: 1)
    end
    
    describe "while logged out" do 
      it "shows all the products" do 
        # Act
        get products_path
        
        # Assert
        must_respond_with :success      
      end
    end 
    
    describe "while logged in" do 
      it "shows all products" do 
        # Act
        perform_login()
        get products_path
        
        # Assert
        must_respond_with :success 
      end
    end
  end 
  
  
  describe "show" do 
    before do 
      # Arrange
      @magician = products(:magician)
    end
    
    describe "while logged out" do 
      it "succeeds for an existing product_id" do 
        # Act
        get product_path(@magician.id)
        
        # Assert
        must_respond_with :success
      end
      
      it "redirects for invalid id" do 
        # Act
        get product_path(246273452735)
        
        # Assert
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end 
    
    describe "while logged in" do 
      it "succeeds for an existing product_id" do 
        # Act 
        perform_login()
        get product_path(@magician.id)
        
        # Assert
        must_respond_with :success
      end
      
      it "redirects for an invalid id" do 
        # Act
        perform_login()
        get product_path(-2)
        
        # Assert
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end
  end 
  
  describe "new" do 
    describe "while logged out" do 
      it "redirects home if not logged in" do 
        #Act
        get new_product_path
        
        # Assert
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end 
    
    describe "while logged in" do 
      it "can get the new product page" do
        # Act
        perform_login()
        get new_product_path
        
        # Assert
        must_respond_with :success
      end
    end 
  end
  
  describe "create" do 
    describe "while logged out" do 
      it "cannot make a new product while logged out" do 
        # Act
        get new_product_path
        
        # Assert
        must_respond_with :redirect
        
      end 
    end 
    
    describe "while logged in" do 
      it "can create a new product" do
        # Arrange
        start_count = Product.all.count
        perform_login()
        
        product_hash = {
          product: {
            name: "Markle Sparkle Princess Dress",
            price: 50.00,
            stock: 5,
            description: "it's a black dress for your fancy pet",
            photo: nil,
            retire: false,
          }
        }      
        
        # Act
        post products_path, params: product_hash
        
        # Assert
        expect(Product.all.count).must_equal (start_count + 1)
        must_respond_with :redirect
        expect(flash[:success]).wont_be_nil
      end

      it "cannot create an invalid product" do 
        # Arrange
        start_count = Product.all.count
        perform_login()
        
        invalid_hash = {
          product: {
            name: nil,
            price: -10.00,
            stock: nil,
            description: "it's a black dress for your fancy pet",
            photo: nil,
            retire: false,
          }
        }
        
          # Act
          post products_path, params: invalid_hash

          # Assert
          expect(Product.all.count).must_equal (start_count)
          must_respond_with :success
          expect(flash[:danger]).wont_be_nil

      end
    end
  end 
  
  describe "edit" do 
    describe "while logged out" do 
      it "redirects home if not logged in" do 
        # Arrange
        @magician = products(:magician)
        
        #Act
        get edit_product_path(@magician.id)
        
        # Assert
        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:warning]).wont_be_nil
      end
    end 
    
    describe "while logged in" do 
      before do 
        #Arrange 
        @magician = products(:magician)
        perform_login(@magician.merchant)
      end 
        it "can get the edit a product page" do 
          # Act
          get edit_product_path(@magician)
        
          # Assert
          must_respond_with :success
          expect(flash[:success]).wont_be_nil
        end
      
        it "cannot edit an invalid product" do 
          # Act
          get edit_product_path(-2)

          # Assert
          must_respond_with :redirect 
        end 

        it "cannot edit another merchant's product" do 
          # Act

          # Arrange
        end
    end 
  end
  
  describe "update" do 
    describe "while logged out" do 
      it "cannot update a product when logged out" do 
        # Arrange 
        @magician = products(:magician)
        
        # Act
        get edit_product_path(@magician.id)
        
        #Assert
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
    
    
    describe "while logged in" do 
      before do 
        @magician = products(:magician)
        perform_login
      end
      it "can update a product" do 
        # Arrange
        update_hash = {
          product: {
            name: "Houdini",
            price: 150.99,
            stock: 12,
            retire: true 
          }
        }
        
        # Act
        patch product_path(@magician.id), params:update_hash
        @magician = Product.find_by(id: @magician.id)
        
        # Assert
        @magician.name.must_equal "Houdini"
        @magician.price.must_equal 150.99
        @magician.stock.must_equal 12
        @magician.retire.must_equal true
      end 

      it "cannot edit an invalid product" do 
        # Act
        get edit_product_path(-2)

        # Assert
        must_respond_with :redirect 
        must_redirect_to root_path
      end 
    end 
  end 
end 
