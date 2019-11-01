class Order < ApplicationRecord
  has_many :orderproducts
  has_many :products, through: :orderproducts #, dependent: nullify

  validates :name, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :mailing_address, presence: true, on: :update
  validates :zip, presence: true, numericality: { only_integer: true }, length: { is: 5 }, on: :update
  validates :name_on_cc, presence: true, on: :update
  validates :cc_number, presence: true, numericality: { only_integer: true }, length: { is: 16 }, on: :update
  validates :cc_cvc, presence: true, numericality: { only_integer: true}, length: {is: 3}, on: :update
  validates :cc_exp, presence: true, on: :update
end
