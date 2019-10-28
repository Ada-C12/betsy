require "test_helper"

describe Wizard do
  describe "validation" do
    it "is invalid with no username" do
      is_invalid = wizards(:wizard1)
      is_invalid.username = nil

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :username
      expect(is_invalid.errors.messages[:username]).must_equal ["can't be blank"]
    end

    it "is invalid if the username is already taken" do
      is_invalid = Wizard.create(username: "zedzorander", email: "kelsier@cosmere.com")

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :username
      expect(is_invalid.errors.messages[:username]).must_equal ["has already been taken"]
    end
    it "is invalid with no email " do
      is_invalid = wizards(:wizard1)
      is_invalid.email = nil

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :email
      expect(is_invalid.errors.messages[:email]).must_equal ["can't be blank", "is invalid"]
    end
    it "is invalid if email is already taken " do
      is_invalid = Wizard.create(username: "Kel", email: "zedzo@greatestmage.com")

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :email
      expect(is_invalid.errors.messages[:email]).must_equal ["has already been taken"]
    end

    it "is invalid if email doesn't follow @____.com format " do
      is_invalid = Wizard.create(username: "Kel", email: "kelcosmere@")

      refute(is_invalid.valid?)
      expect(is_invalid.errors.messages).must_include :email
      expect(is_invalid.errors.messages[:email]).must_equal ["is invalid"]
    end
  end

  describe "relationships" do
    it "it can add product through products" do
      wizard_no_products = wizards(:wizard_no_products)
      product = products(:product1)

      wizard_no_products.products << product

      expect(wizard_no_products.products.count).must_equal 1
      wizard_no_products.products.each do |product|
        product.must_be_kind_of Product
      end
    end
  end
end
