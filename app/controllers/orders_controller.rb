class OrdersController < ApplicationController
  def create
    @order = Order.new(status: pending)

  end


  # checkout form will be the edit form

  # checkout button will be the update action
end
