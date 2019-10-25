class Order < ApplicationRecord
  has_many :order_items

  validates :status, presence: true
  validates :name, presence: true, if: :not_pending?
  validates :email, presence: true, format: { with: /@/, message: "Email format must be valid." } , if: :not_pending?
  validates :address, presence: true, if: :not_pending?
  validates :cc_name, presence: true, if: :not_pending? 
  validates_numericality_of :cc_last4, within: 1000..9999, if: :not_pending?
  validates :cc_exp, presence: true, if: :not_pending?
  validates_numericality_of :cc_cvv, greater_than: 0, if: :not_pending?
  validates :billing_zip, presence: true, if: :not_pending?
  
  def not_pending?
    status != 'pending'
  end
end
