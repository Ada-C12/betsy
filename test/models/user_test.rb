require "test_helper"

describe User do
  describe "validations" do 
    before do
      @users = User.all
    end

    it "can be valid" do
      @users.each do |user|
        assert(user.valid?)
      end
    end

    it "will have the required fields" do
      @users.each do |user|
        [:uid, :merchant_name, :email, :provider, :username].each do |field|
          expect(user).must_respond_to field
        end
      end
    end

    it "requires a unique uid" do
      user = users(:ada)
      taken_uid = users(:betsy).uid
      user.uid = taken_uid

      refute(user.valid?)
    end
    
    it "requires a unique username" do
      user = users(:ada)
      taken_username = users(:betsy).username
      user.username = taken_username

      refute(user.valid?)
    end

    it "requires a unique email address" do
      user = users(:ada)
      taken_email = users(:betsy).email
      user.email = taken_email

      refute(user.valid?)
    end

    it "must have a unique merchant name, if present" do
      user = users(:ada)
      taken_merchant_name = users(:betsy).merchant_name
      user.merchant_name = taken_merchant_name

      refute(user.valid?)
    end

    it "requires merchant_name to be less than 50 characters" do
      user = users(:gretchen)
      user.merchant_name = (0...51).map { ('a'..'z').to_a[rand(26)] }.join
      
      refute(user.valid?)
    end

    it "requires an at symbol (@) to be present in the email address" do
      user = users(:betsy)
      user.email = "bfruitstand.com"

      refute(user.valid?)
    end
  end

  describe "relationships" do
    it "can have many products" do
      user = users(:ada)
      product_1 = Product.first
      product_2 = Product.last

      user.products << product_1
      user.products << product_2

      expect(user.products.count).must_be :>=, 0

      user.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end

end
