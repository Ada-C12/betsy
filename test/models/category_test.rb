require "test_helper"

describe Category do
  it "can be instantiated" do
  end

  describe "validations" do
  end

  describe "relations" do
  end

  describe "custom methods" do
  before do
    @FIXED_CATEGORIES_COUNT = 6
  end
    describe "fixed_categories class method" do
      it "returns the categories where ids match ids in the constant FIXED_CATEGORY_IDS" do
        fixed_categories = Category.fixed_categories
        expect(fixed_categories.length).must_equal @FIXED_CATEGORIES_COUNT
      end
    end
     
    describe "more_categories class method" do
      it "returns the categories where ids do NOT match ids in the constant FIXED_CATEGORY_IDS" do
        more_categories = Category.more_categories
        expect(more_categories.length).must_equal Category.count - @FIXED_CATEGORIES_COUNT
      end
    end

    describe "all_alphabetized class method" do
    end
    describe "select_options_names_ids" do
    end

  end
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
end
