require "test_helper"

describe CategoriesController do
  describe "show" do 
    describe "while logged out" do 
      it "shows products by category" do 
        # Arrange
        puppy = categories(:puppy)

        # Act
        get category_path(puppy.id)
        
        # Assert
        must_respond_with :success
      end

      it "redirects with invalid category" do 
        # Act
        get category_path(-20)

        # Assert
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "while logged in" do 
      it "shows product by category" do 
        # Arrange
        puppy = categories(:puppy)

        # Act
        perform_login()
        get category_path(puppy.id)


        # Assert
        must_respond_with :success
      end 
    end
  end 

  describe "new" do 
    describe "while logged out" do 
      it "redirects to homepage if not logged in" do 
      # Act
      get new_category_path

      # Assert
      must_respond_with :redirect
      must_redirect_to root_path
      end 
    end

    describe "while logged in" do 
      it "can get a new category page" do 
      # Arrange
      perform_login()

      # Act
      get new_category_path

      # Assert
      must_respond_with :success
      end
    end
  end 

  describe "create" do 
    describe "while logged out" do 
      it "cannot create a new category when logged out" do 
        # Act
        get new_product_path

        # Assert
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "while logged in" do 
      before do 
        # Arrange
        @start_count = Category.all.count
        perform_login()
      end
        it "can create a product when logged in" do 
          # Arrange
          category_hash = {
            category: {
              name: "elf"
            }
          }
        
          # Act
          post categories_path, params: category_hash

          # Assert
          expect(Category.all.count).must_equal (@start_count + 1)
          must_redirect_to root_path
          must_respond_with :redirect
          must_redirect_to root_path
        end

        it "cannot create an invalid category" do 
          # Arrange
          invalid_category = {
            category: {
              name: nil
            }
          }

          # Act
          post categories_path, params: invalid_category

          # Assert
          expect(Category.all.count).must_equal @start_count
          expect(flash[:warning]).wont_be_nil 
      end
    end 
  end 
end
