require "test_helper"

describe CategoriesController do
  describe "new" do
    it "should get the new form" do
      get new_category_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new category" do
      new_category = {
        category: {
          name: "new category",
        },
      }

      expect {
        post categories_path, params: new_category
      }.must_change "Category.count", 1
    end

    it "will not create a new category with bad data" do
      category_hash = {
        category: {
          name: "",
        },
      }

      expect {
        post categories_path, params: category_hash
      }.wont_change "Category.count"

      must_respond_with :bad_request
    end
  end
end
