class AddOrderTableColumns < ActiveRecord::Migration[5.2]
  def change
    add_column(:orders, :name, :string)
    add_column(:orders, :address, :string)
    add_column(:orders, :email, :string)
    add_column(:orders, :credit_card_num, :integer)
    add_column(:orders, :expiration_date, :date)
    add_column(:orders, :cvv, :integer)
    add_column(:orders, :zip, :integer)
  end
end
