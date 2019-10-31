require "test_helper"

describe ApplicationHelper, :helper do
  describe "readable date" do
    it "returns a string with a date in 'Mon DD, YYYY' format if given a vaild date" do
      date = ActiveSupport::TimeZone['UTC'].parse("03/10/2019")

      formatted_date = readable_date(date)

      expect(formatted_date).must_be_kind_of String
      expect(formatted_date).must_include "Oct"
    end

    it "returns '[unknown]' if given an invalid date" do
      invalid_date = "a date"

      formatted_date = readable_date(invalid_date)

      expect(formatted_date).must_be_kind_of String
      expect(formatted_date).must_equal "[unknown]"
    end

    it "returns '[unknown]' if given nil" do
      invalid_date =  nil

      formatted_date = readable_date(invalid_date)

      expect(formatted_date).must_be_kind_of String
      expect(formatted_date).must_equal "[unknown]"
    end
  end

  describe "currency format" do
    it "returns a string in '$0.00' format if given an integer" do
      num = 50
      num_2 = -8

      formatted_num = currency_format(num)
      formatted_num_2 = currency_format(num_2)

      expect(formatted_num).must_be_kind_of String
      expect(formatted_num).must_equal "$50.00"
      expect(formatted_num_2).must_be_kind_of String
      expect(formatted_num_2).must_equal "$-8.00"
    end

    it "returns a string in '$0.00' format if given a float" do
      num = 5.55
      num_2 = -8.78

      formatted_num = currency_format(num)
      formatted_num_2 = currency_format(num_2)

      expect(formatted_num).must_be_kind_of String
      expect(formatted_num).must_equal "$5.55"
      expect(formatted_num_2).must_be_kind_of String
      expect(formatted_num_2).must_equal "$-8.78"
    end

    it "returns nil if given an invalid number" do
      value = "7"
      value_2 = "!"

      result = currency_format(value)
      result_2 = currency_format(value_2)

      expect(result).must_be_nil
    end

    it "returns nil if given nil" do
      value = nil

      result = currency_format(value)

      expect(result).must_be_nil
    end
  end

end
