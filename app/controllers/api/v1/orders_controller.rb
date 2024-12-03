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
      @order.receipt_number = razorpay_order.receipt
      @order.total_price = total_amount / 100.0
      @order.payment_status = 'created'
      @order.status = 'created'

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
        send_order_notification
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

  def cancel
    @order = @current_user.orders.find_by(id: params[:id])
    @order_item = @order.order_items.find_by(id: params[:order_item_id])
  
    if @order_item.nil?
      render json: { message: 'Order item not found' }, status: :not_found
      return
    end
  
    if @order_item.status == 'cancelled'
      render json: { message: 'Order item has already been cancelled' }, status: :unprocessable_entity
      return
    end
  
    if @order.payment_status == 'created' && @order_item.return_status == 'not_returned'
      address = Address.find_by(id: @order.address_id)
      @return = Return.new(
        order: @order,
        order_item: @order_item,
        address: address,
        reason: params[:reason],
        more_information: params[:more_information]
      )
  
        if @return.save
          @order_item.update(status: 'cancelled')
          updating_price_of_order_after_remove_some_ordere_item_from_order(@order, @order_item)
          render json: { message: 'Order item canceled successfully' }, status: :ok
        end
    elsif @order.payment_status == 'paid' && @order_item.return_status != 'delivered'
      cancel_order_item_with_refund(@order, @order_item)
    else
      render json: { message: 'Order item cannot be canceled' }, status: :unprocessable_entity
    end
  end 
  
  def exchange_order
    @order = @current_user.orders.find_by(id: params[:order_id])
    unless @order
      render json: { message: 'Order not found' }, status: :not_found
      return
    end
  
    @order_item = @order.order_items.find_by(id: params[:order_item_id])
    unless @order_item
      render json: { message: 'Order item not found' }, status: :not_found
      return
    end
  
    unless @order.payment_status == 'paid'
      render json: { message: 'Exchange request cannot be created as payment is not completed' }, status: :unprocessable_entity
      return
    end
  
    if @order_item.return_status == 'exchange_requested'
      render json: { message: 'Order item exchange request is already in process' }, status: :unprocessable_entity
      return
    end
  
    unless @order_item.delivered? || @order_item.not_returned?
      render json: { message: 'Order item cannot be exchanged at this stage' }, status: :unprocessable_entity
      return
    end
  
    address = Address.find_by(id: @order.address_id)
    unless address
      render json: { message: 'Address not found' }, status: :not_found
      return
    end
  
    @exchange = Return.new(
      order: @order,
      order_item: @order_item,
      address: address,
      reason: params[:reason],
      more_information: params[:more_information]
    )
  
    if @exchange.save
      @order_item.update(return_status: :return_requested, status: :processing)
      render json: { message: 'Exchange request created successfully', exchange: @exchange }, status: :ok
    else
      render json: { errors: @exchange.errors.full_messages }, status: :unprocessable_entity
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

  def order_item_details
    @order = @current_user.orders.find_by(id: params[:order_id])
    unless @order
      render json: { message: 'Order not found' }, status: :not_found
      return
    end
  
    @order_item = @order.order_items.find_by(id: params[:order_item_id])
    unless @order_item
      render json: { message: 'Order item not found' }, status: :not_found
      return
    end
  
    render json: @order_item, serializer: OrderItemDetailSerializer, status: :ok
  end  

  private

  def updating_price_of_order_after_remove_some_ordere_item_from_order(order, order_item)
    new_total_price = order.total_price - order_item.total_price  
    order.update!(total_price: new_total_price)
  end

  def cancel_order_item_with_refund(order, order_item)
    ActiveRecord::Base.transaction do
      refund_amount = order_item.total_price
      begin
        razorpay_payment = Razorpay::Payment.fetch(order.razorpay_payment_id)
        refund_amount_in_paise = (refund_amount * 100).to_i
        refund = razorpay_payment.refund(amount: refund_amount_in_paise, speed: 'normal')

        Refund.create!(
          refund_id: refund.id,
          amount: refund.amount / 100.0,
          status: refund.status,
          order: order,
          order_item: order_item
        )

        order_item.update!(return_status: 'canceled')

        render json: { message: 'Order item canceled and refunded successfully', refund: refund }, status: :ok
      rescue Razorpay::Error => e
        raise ActiveRecord::Rollback, "Refund failed: #{e.message}"
      end
    end
  end

  def order_params
    params.permit(:total_price, :address_id, :coupon_id)
  end

  def send_order_notification
    OrderNotificationService.new(@order).call
    FcmNotificationService.new(@order).call
  end
end