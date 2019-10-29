class Merchant < ApplicationRecord
  has_many :products

  validates :uid, uniqueness: true, presence: true
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    return merchant
  end

  # def self.orderitems
  # @products = Product.where(merchant_id: session[:merchant_id])

  #   merchant_orderitems = []
  #   @products.each do |product|
  #     product.orderitems.each do |orderitem|
  #       if orderitem.shipped == false && orderitem.order.status == 'paid'
  #         merchant_orderitems << orderitem
  #       end
  #     end
  #   end
  #   return merchant_orderitems
  # end
end
