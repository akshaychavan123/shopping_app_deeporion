class Api::V1::CardOrdersController < ApplicationController
	before_action :authorize_request

	def create
    gift_card = GiftCard.find_by(id: card_order_params[:gift_card_id])

    if gift_card.nil?
      render json: { error: 'Gift card not found' }, status: :not_found
      return
    end

    @card_order = CardOrder.new(card_order_params)
    @card_order.price = gift_card.price

    if @card_order.save
      render json: @card_order, status: :created
    else
      render json: @card_order.errors, status: :unprocessable_entity
    end
  end

	private

	def card_order_params
		params.require(:card_order).permit(:gift_card_id, :recipient_name, :recipient_email, :dob, :sender_email, :message, :razorpay_order_id, :razorpay_payment_id, :payment_status, :order_status)
	end
end
