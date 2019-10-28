class Order < ApplicationRecord
  has_many :order_items

  validates :status, presence: true
  validates :name, presence: true, if: :not_pending?
  validates :email, presence: true, format: { with: /@/, message: "Email format must be valid." } , if: :not_pending?
  validates :address, presence: true, if: :not_pending?
  validates :cc_name, presence: true, if: :not_pending? 
  validates :cc_last4, presence: true, if: :not_pending?
  # , within: 1000..9999
  validates :cc_exp, presence: true, if: :not_pending?
  validates_numericality_of :cc_cvv, greater_than: 0, if: :not_pending?
  validates :billing_zip, presence: true, if: :not_pending?
  
  def not_pending?
    status != 'pending'
  end

  def contains_orderitems?
    self.order_items.each do |order_item|
      return true if order_item.product.user_id == session[:user_id]
    end
    return false
  end

end
