require "test_helper"

describe ApplicationHelper, :helper do
  describe 'merchant drop-down' do
    it "lists the merchants in a drop-down" do 
      # Arrange 
      all_merchants = Merchant.all 

      # Act
      merch_drop_down = merchants_dropdown
    
      # Assert
      expect(merch_drop_down).must_be_kind_of String
      all_merchants.each do |merchant|
        expect(merch_drop_down).must_include(merchant.username)
      end
    end 
  end

  describe 'category drop-down' do
    it "lists the categories in a drop-down" do 
      # Arrange
      all_categories = Category.all

      # Act
      categories_drop_down = categories_dropdown

      # Assert
      expect(categories_drop_down).must_be_kind_of String
      all_categories.each do |category|
        expect(categories_drop_down).must_include(category.name)
      end
    end
  end
end