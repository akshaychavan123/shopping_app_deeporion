class Api::V1::ReturnsController < ApplicationController
  before_action :authorize_request

  def create
    ActiveRecord::Base.transaction do
      @order = @current_user.orders.find(params[:order_id])
      @order_item = @order.order_items.find(params[:order_item_id])
      @address = @current_user.addresses.find(params[:address_id])
      refund_amount = @order_item.total_price

      @return = Return.new(
        order: @order,
        order_item: @order_item,
        address: @address,
        reason: params[:reason],
        refund_amount: refund_amount,
        refund_method: params[:refund_method],
        more_information: params[:more_information]
      )

      if @return.save
        @order_item.update!(return_status: 'returned')
        process_partial_refund(@order, @order_item)
        render json: { message: 'Return processed successfully', return: @return }, status: :created
      else
        render json: { errors: @return.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: 'Order or item not found', error: e.message }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def process_partial_refund(order, order_item)
    begin
      razorpay_payment = Razorpay::Payment.fetch(order.razorpay_payment_id)
      refund_amount_in_paise = (order_item.total_price * 100).to_i
      refund = razorpay_payment.refund(amount: refund_amount_in_paise, speed: 'normal')

      Refund.create!(
        refund_id: refund.id,
        amount: refund.amount / 100.0,
        status: refund.status,
        order: order,
        order_item: order_item
      )

      # order.update!(status: 'partially_refunded') if order.order_items.not_returned.empty?

    rescue Razorpay::Error => e
      raise ActiveRecord::Rollback, "Refund failed: #{e.message}"
    end
  end
end
