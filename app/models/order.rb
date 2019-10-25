class Order < ApplicationRecord
  has_many :order_items

  validates :order_items, :length => { :minimum => 1 }
  validates :email, presence: true
  validates :name, presence: true
  validates :owling_address, presence: true
  validates :cc_num, presence: true
  validates :cc_exp_mo, presence: true
  validates :cc_exp_yr, presence: true
  validates :cc_cvv, presence: true
  validates :zip_code, presence: true
  validates :status, presence: true
  validates_inclusion_of :retired, in: [true, false]
end
