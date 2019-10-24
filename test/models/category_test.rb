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
      it "returns categories in ascending alphabetical order" do
        all_alphabetized = Category.all_alphabetized
        current_category_name = all_alphabetized.first.name
        all_alphabetized.each do |category|
          expect(category.name).must_be :>=, current_category_name
          current_category_name = category.name
        end
      end
    end

    describe "select_options_names_ids" do
      it "returns an array of arrays for menu buttons [[category.name, category.id]]" do
        select_options_names_ids = Category.select_options_names_ids
        expect(select_options_names_ids.length).must_equal Category.count
        expect(select_options_names_ids).must_be_instance_of Array
        expect(select_options_names_ids.first).must_be_instance_of Array
      end
    end

  end
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
end
