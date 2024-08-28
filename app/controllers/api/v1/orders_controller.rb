class Api::V1::OrdersController < ApplicationController
  before_action :authorize_request

  def create
    ActiveRecord::Base.transaction do
      total_amount = (order_params[:total_price].to_f * 100).to_i
      
      razorpay_order = Razorpay::Order.create(
        amount: total_amount,
        currency: 'INR',
        receipt: "order_#{SecureRandom.hex(8)}"
      )

      @order = current_user.orders.new(order_params)
      @order.razorpay_order_id = razorpay_order.id
      @order.total_price = total_amount / 100.0
      @order.payment_status = 'created'

      cart_items = current_user.cart.cart_items

      cart_items.each do |cart_item|
        @order.order_items.build(
          cart_item_id: cart_item.id
        )
      end

      if @order.save
        cart_items.destroy_all # Clear the cart
        render json: { order: @order, razorpay_order_id: razorpay_order.id }, status: :created
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: { error: 'Failed to create order. Please try again.' }, status: :unprocessable_entity
  end

  private

  def order_params
    params.require(:order).permit(:total_price, :address_id, :payment_status)
  end
end