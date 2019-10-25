class Order < ApplicationRecord
  has_many :order_items

  validates :status, presence: true 
  validates :name, presence: true
  validates :email, presence: true, format: { with: /@/, message: "Email format must be valid." }
  validates :address, presence: true 
  validates :cc_name, presence: true 
  validates_numericality_of :cc_last4, within: 1000..9999
  validates :cc_exp, presence: true 
  validates_numericality_of :cc_cvv, greater_than: 0
  validates :billing_zip, presence: true 
  
end
