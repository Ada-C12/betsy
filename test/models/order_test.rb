require "test_helper"

describe Order do
  describe 'validations' do
    before do
      @order = Order.new(status: "paid", name: "Jane Doe", email: "jane@petsy.com", mailing_address: "123 Main Street", zip: 98110, name_on_cc: "Jane X. Doe", cc_number: 1234567890123456, cc_cvc: 123, cc_exp: "12/31/56")
    end
    it 'can be made with valid input' do
      @order.update(name: "John Doe")
      expect(@order.valid?).must_equal true
    end
    it 'on update, is invalid without a name' do
      @order.update(name: nil)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :name
    end
    it 'on update, is invalid without an email' do
      @order.update(email: nil)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :email
    end
    it 'on update, is invalid without a mailing address' do
      @order.update(mailing_address: nil)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :mailing_address
    end
    it 'on update, is invalid without a five-digit integer zip code' do
      @order.update(zip: nil)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :zip
      @order.update(zip: 1234)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :zip
      @order.update(zip: 'abcd')
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :zip
    end
    it 'on update, is invalid without a credit card name' do
      @order.update(name_on_cc: nil)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :name_on_cc
    end
    it 'on update, is invalid without a sixteen-digit credit card number' do
      @order.update(cc_number: nil)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cc_number
      @order.update(cc_number: 1234)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cc_number
      @order.update(cc_number: 'abcd')
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cc_number
    end
    it 'on update, is invalid without a three-digit integer credit card cvc' do
      @order.update(cc_cvc: nil)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cc_cvc
      @order.update(cc_cvc: 1234)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cc_cvc
      @order.update(cc_cvc: 'abcd')
      expect(@order.errors.messages).must_include :cc_cvc
      expect(@order.errors.messages).must_include :cc_cvc
    end
    it 'on update, is invalid without a credit card expiration date' do
      @order.update(cc_exp: nil)
      expect(@order.valid?).must_equal false
      expect(@order.errors.messages).must_include :cc_exp
    end
  end

  describe 'relations' do
    it 'has products' do
      order = orders(:c)
      order.products.length.must_equal 2
    end

    it 'can set the products' do
      order = Order.new
      order.products << products(:magician)
      order.products.first.id.must_equal products(:magician).id
    end
  end
end
