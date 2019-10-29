class Wizard < ApplicationRecord
  has_many :products

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def total_revenue
    total = 0
    self.products.each do |product|
      product.order_items.each do |item|
        total += item.subtotal
      end
    end
    return total
  end

  def total_revenue_by_status(status)
    total = 0
    self.products.each do |product|
      product.order_items.each do |item|
        if item.order.status == status
          total += item.subtotal
        end
      end
    end
    return total
  end

  def orders
    orders = []

    self.products.each do |product|
      product.order_items.each do |order_item|
        orders << order_item.order
      end
    end
    return orders.uniq
  end

  def orders_by_status(input_status)
    return self.orders.select { |order| order.status == input_status}
  end
end
