class ChangeDataTypeInOrder < ActiveRecord::Migration[5.2]
  def change
    change_column(:orders, :cc_number, :bigint)
  end
end
