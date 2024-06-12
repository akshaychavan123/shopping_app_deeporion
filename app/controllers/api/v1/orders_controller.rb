class Api::V1::OrdersController < ApplicationController
  # before_action :authorize_request

  def create
    # @order = current_user.orders.new(order_params)
    @order = Order.new(order_params)


    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :user_id, :first_name, :last_name, :phone_number, :email, :country,
      :pincode, :area, :city, :state, :address, :total_price,
      :address_type, :payment_status, :placed_at,
      order_items_attributes: [:product_item_id, :quantity]
    )
  end

end
