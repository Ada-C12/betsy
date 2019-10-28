class Type < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, allow_blank: false, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }, uniqueness: true

end
