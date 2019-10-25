class Order < ApplicationRecord
  has_many :orderitems
  has_many :products, through: :orderitems
  
  validates :status, presence: true
  
  validates :orderitems, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :cc_name, presence: true, on: :update
  validates :cc_num, presence: true, on: :update, numericality: { only_integer: true }
  validates :cvv, presence: true, on: :update, numericality: { only_integer: true }
  validates :cc_exp, presence: true, on: :update
  validates :zip, presence: true, on: :update, numericality: { only_integer: true }
end
