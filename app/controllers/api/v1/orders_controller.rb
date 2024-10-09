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

      @order = @current_user.orders.new(order_params)
      @order.razorpay_order_id = razorpay_order.id
      @order.order_number = razorpay_order.receipt
      @order.total_price = total_amount / 100.0
      @order.payment_status = 'created'

      cart_items = @current_user.cart.cart_items

      cart_items.each do |cart_item|
        @order.order_items.build(
          product_item_id: cart_item.product_item_id,
          product_item_variant_id: cart_item.product_item_variant_id,
          quantity: cart_item.quantity,
          total_price: cart_item.total_price
        )
      end

      if @order.save
        cart_items.destroy_all
        render json: { order: @order }, status: :created
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: { error: 'Failed to create order. Please try again.' }, status: :unprocessable_entity
  end

  def callback
    begin
      razorpay_payment = Razorpay::Payment.fetch(params[:razorpay_payment_id])
      razorpay_order = Razorpay::Order.fetch(params[:razorpay_order_id])

      if razorpay_payment.status == 'captured'
        order = Order.find(params[:order_id])
        order.update(status: 'paid')
        render json: { message: 'Payment successful', order: order }, status: :ok
      else
        render json: { message: 'Payment failed', status: razorpay_payment.status }, status: :unprocessable_entity
      end
    rescue Razorpay::Error => e
      render json: { message: "Payment verification failed", error: e.message }, status: :unprocessable_entity
    end
  end

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
    params.permit(:total_price, :address_id)
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