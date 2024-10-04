class Api::V1::OrdersController < ApplicationController
  before_action :authorize_request

  def save_order_data
    @order_data = Order.new(order_data_params)
    if @order_data.save
      cart_items = @current_user.cart.cart_items
      cart_items.destroy_all
      OrderMailer.order_confirmation(@order_data).deliver_later
      render json: @order_data, status: :created
    else
      render json: { message: 'Something went wrong', errors: @order_data.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def order_history
    orders = Order.where(user_id: @current_user.id)
    orders = orders.includes(:order_items).order(created_at: :desc)

    if orders.present?
      render json: orders, status: :ok, each_serializer: OrderHistorySerializer
    else
      render json: { message: 'No orders found' }, status: :not_found
    end
  end

  private

  def order_params
    params.require(:order).permit(:total_price, :address_id, :payment_status)
  end

  def order_data_params
    params.permit(
      :total_price, 
      :address_id, 
      :user_id,
      :payment_status, 
      :razorpay_order_id, 
      :razorpay_payment_id, 
      order_items_attributes: [:order_id, :product_item_id, :product_item_variant_id, :quantity, :total_price, :status]
    )
  end

  def generate_custom_order_number
    last_order = Order.order(:created_at).last
    sequence_number = last_order.nil? ? 1 : last_order.order_number.split('-').last.to_i + 1
    self.order_number = "ORD-#{Time.current.strftime('%Y%m%d')}-#{sequence_number.to_s.rjust(6, '0')}"
  end

end