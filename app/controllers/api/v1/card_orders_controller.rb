class Api::V1::CardOrdersController < ApplicationController
	before_action :authorize_request

  def create
    gift_card = GiftCard.find_by(id: card_order_params[:gift_card_id])

    if gift_card.nil?
      render json: { error: 'Gift card not found' }, status: :not_found
      return
    end

    total_amount = (gift_card.price.to_f * 100).to_i

    razorpay_order = Razorpay::Order.create(
      amount: total_amount,
      currency: 'INR',
      receipt: "order_#{SecureRandom.hex(8)}"
    )

    @card_order = CardOrder.new(card_order_params)
    @card_order.price = gift_card.price
    @card_order.razorpay_order_id = razorpay_order.id 

    if @card_order.save
      render json: @card_order, status: :created
    else
      render json: { errors: @card_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def callback
    begin
      razorpay_payment = Razorpay::Payment.fetch(params[:razorpay_payment_id])
      razorpay_order = Razorpay::Order.fetch(params[:razorpay_order_id])

      if razorpay_payment.status == 'captured'
        @card_order = CardOrder.find_by(razorpay_order_id: razorpay_order.id)

        if @card_order.nil?
          render json: { message: 'Order not found' }, status: :not_found
          return
        end

        @card_order.update(payment_status: 'paid', order_status: 'completed')
        GiftCardMailer.send_gift_card(@card_order).deliver_now
        render json: { message: 'Payment successful and email sent', order: @card_order }, status: :ok
      else
        render json: { message: 'Payment failed', status: razorpay_payment.status }, status: :unprocessable_entity
      end
    rescue Razorpay::Error => e
      render json: { message: "Payment verification failed", error: e.message }, status: :unprocessable_entity
    end
  end

	private

	def card_order_params
		params.require(:card_order).permit(:gift_card_id, :recipient_name, :recipient_email, :dob, :sender_email, :message, :razorpay_order_id, :razorpay_payment_id, :payment_status, :order_status)
	end
end
